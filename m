Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbXAaHGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbXAaHGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 02:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbXAaHGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 02:06:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbXAaHGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 02:06:12 -0500
To: akuster <akuster@mvista.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] PM: fast power off - driver
References: <45BBB09C.7020509@mvista.com>
From: Andi Kleen <ak@suse.de>
Date: 28 Jan 2007 04:20:14 +0100
In-Reply-To: <45BBB09C.7020509@mvista.com>
Message-ID: <p7364aron0x.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akuster <akuster@mvista.com> writes:

> My apologies, I cc'd the wrong list the first time around.
> 
> - Armin
> ---
> 
> Fastpoweroff default profile driver

Why don't you just call the existing reboot(2)? I've had a simple 
C program that does a very fast poweroff (or reboot) forever
and it works just fine. It won't kill all processes,
but if you really want to do that you can use killall -r .* first.

-Andi

