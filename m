Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbXGNPVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbXGNPVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 11:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756860AbXGNPVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 11:21:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64817 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643AbXGNPVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 11:21:04 -0400
Date: Sat, 14 Jul 2007 17:20:04 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3][try 1] init: enable system-on-initramfs
In-Reply-To: <469801B7.7010909@zytor.com>
Message-ID: <Pine.LNX.4.58.0707141629510.5288@be1.lrz>
References: <Pine.LNX.4.58.0707132039080.3222@be1.lrz> <4697D6EB.5020404@zytor.com>
 <Pine.LNX.4.58.0707132344140.13842@be1.lrz> <469801B7.7010909@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18RNJaw7Ds6PsguGamJJsgWVSwOeWnATkUFrFY
 SM2fQGCcZEB1lXACTem6PkVgcqTBGHzWH+9dDQBT6BWeKk/rLA
 R89NemmEcTAwqBJwP4XGA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007, H. Peter Anvin wrote:
> Bodo Eggert wrote:
> > On Fri, 13 Jul 2007, H. Peter Anvin wrote:
> >> Bodo Eggert wrote:

> >>> I toyed with setting up a diskless system in initramfs. In the process, I
> >>> came across some things:
> >>>
> >>> 1)  There is no way to have the kernel not mount a filesystem,
> >>>     unless you use /init or rdinit=.
> >> And?  Just use rdinit=/sbin/init and no patch is needed.
> > 
> > rdinit is supposed to do a different job from /sbin/init, therefore it
> > will not do the security callbacks the original code would do.
> > 
> > And besides that, it feels like turning the wrong knob for that task.
> 
> No, it is exactly the right knob for the task.

Setting the name of the rdinit process to the name of the init process
in order to select the root device should not be the right knob.

> The fact that the security callbacks don't get invoked when using an
> initramfs *AT ALL* is the real problem.

It's one more problem.
-- 
Interchangeable parts aren't. 
