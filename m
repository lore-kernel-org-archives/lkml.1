Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbZD0Xae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbZD0Xae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 19:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbZD0XaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 19:30:06 -0400
Received: from main.gmane.org ([80.91.229.2]:50169 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158AbZD0XaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:30:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Florian Mickler <florian@mickler.org>
Subject: Re: 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = corruption
Date: Mon, 27 Apr 2009 23:49:47 +0200
Message-ID: <20090427234947.394f774f@schatten>
References: <b2cdc9f30904182327w12a3ec32t90c7c6c34980577b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: f053212151.adsl.alicedsl.de
X-Newsreader: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Cc: xorg@freedesktop.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Apr 2009 07:27:35 +0100
Alex Bennee <kernel-hacker@bennee.com> wrote:

> Heading the warnings in the menuconfig I did try and ensure I have all
> the up to date parts of user-space. With KMS enabled GDM starts up but
> then corrupts the display with vertical lines. Disabling the kernel
> config and everything starts up fine, UXA acceleration seems OK and
> the speed of compiz is finally back up to ~60fps thanks to the A17
> fix.
> 
> Am I missing another bit of user space for KMS to work properly?
> 
> I am seeing a:
> 
> [    6.751092] BUG: using smp_processor_id() in preemptible [00000000]
> code: modprobe/3078
> [    6.751100] caller is smp_call_function_many+0x29/0x1bd
> [    6.751103] Pid: 3078, comm: modprobe Not tainted 2.6.30-rc2-ajb
> #56
> 
> But I think it's unrelated to any X woes. Shall detail in another
> message.
> 

hm, are you using the xf86-video-intel git-branch "2.7"? if i use that,
i need a kernel fix queued in eanholts for-linus git-tree or else i
also get unusable X. 

i assumed that this was because of some not-yet-released fixes
on the 2.7-branch which will get released as soon as erics queue is
merged? but i didn't double check ...  maybe the released version is
also broken in this regard for me....


