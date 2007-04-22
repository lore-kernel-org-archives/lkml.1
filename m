Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbXDVW2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbXDVW2F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 18:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbXDVW2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 18:28:04 -0400
Received: from ns2.suse.de ([195.135.220.15]:51127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbXDVW2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 18:28:03 -0400
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: emoenke@gwdg.de, minyard@wf-rch.cirr.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use spinlock instead of binary mutex in CDU-31A driver
References: <20070422213531.GO5013@traven>
From: Andi Kleen <andi@firstfloor.org>
Date: 23 Apr 2007 01:25:58 +0200
In-Reply-To: <20070422213531.GO5013@traven>
Message-ID: <p737is43sah.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Kaehlcke <matthias.kaehlcke@gmail.com> writes:

> -static DECLARE_MUTEX(sony_sem);		/* Semaphore for drive hardware access */
> +static DEFINE_MUTEX(sony_mtx);		/* Mutex for drive hardware access */

That's not a spinlock.  Also normally some rationale is added to the
description for a change?

-Andi
