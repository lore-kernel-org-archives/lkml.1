Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZAZRIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZAZRIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbZAZRHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:07:52 -0500
Received: from styx.suse.cz ([82.119.242.94]:44076 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751550AbZAZRHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:07:51 -0500
Date: Mon, 26 Jan 2009 18:07:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
cc: Nick Andrew <nick@nick-andrew.net>,
       Trivial Kernel Patches <trivial@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [TRIVIAL PATCH 00/20] Fix misspelling of "firmware"
In-Reply-To: <497DCB15.7030404@turknet.net.tr>
Message-ID: <alpine.LNX.1.10.0901261806290.5377@jikos.suse.cz>
References: <20090126015921.15168.97302.stgit@marcab.local.tull.net> <alpine.LNX.1.10.0901261059560.5377@jikos.suse.cz> <497DCB15.7030404@turknet.net.tr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009, Tarkan Erimer wrote:

> "Fix misspelling of firmware in tg3.c" didn't help me to solve tg3 
> firmware issue which I submitted via "[BUG] tg3 module problem on 
> Linux-2.6.29-rc1-2" subjected email at 21st of Jan. I re-compiled 
> 2.6.29-rc2 with this patch and still having the same error message :
> Using mkinitramfs-kpkg to build the ramdisk.
> W: Possible missing firmware /lib/firmware/2.6.29-rc2-git1/tigon/tg3_tso5.bin
> for module tg3
> W: Possible missing firmware /lib/firmware/2.6.29-rc2-git1/tigon/tg3_tso.bin
> for module tg3
> W: Possible missing firmware /lib/firmware/2.6.29-rc2-git1/tigon/tg3.bin for
> module tg3

Yes, Nick's patch is not supposed to fix this, it's just a fix of a 
comment in the source code, that has no effect on the behavior of the 
driver. So this is completely separate issue, that you should report to 
the proper place, which is

	BROADCOM TG3 GIGABIT ETHERNET DRIVER
	P:      Michael Chan
	M:      mchan@broadcom.com
	L:      netdev@vger.kernel.org
	S:      Supported

-- 
Jiri Kosina
SUSE Labs
