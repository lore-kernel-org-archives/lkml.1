Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYAVEVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYAVEVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 23:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbYAVEU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 23:20:59 -0500
Received: from ns2.suse.de ([195.135.220.15]:57911 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbYAVEU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 23:20:58 -0500
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/6] RFC: Typesafe callbacks
References: <200801202046.14746.rusty@rustcorp.com.au>
	<200801212233.04989.rusty@rustcorp.com.au>
	<47949257.1000102@gmail.com>
	<200801221027.15002.rusty@rustcorp.com.au>
From: Andi Kleen <andi@firstfloor.org>
Date: 22 Jan 2008 05:20:55 +0100
In-Reply-To: <200801221027.15002.rusty@rustcorp.com.au>
Message-ID: <p73bq7eo5i0.fsf@crumb.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:
> ===
> Attempt to create callbacks which take unsigned long as well as
> correct pointer types.

FWIW i had something similar using the gcc union extension at some
point for ioctls because I was tired for all the ugly casts from
unsigned long arg to void * in ioctl handlers.

But I decided to not push it because sparse would have likely choked 
on it, and sparse actually finds a lot of bugs so it's more important than
having a few more casts.

-Andi
