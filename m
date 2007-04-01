Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbXDAACF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbXDAACF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 20:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXDAACF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 20:02:05 -0400
Received: from main.gmane.org ([80.91.229.2]:37825 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbXDAACD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 20:02:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: [RFC] UML kernel & rootfs bundle with every kernel release ?
Date: Sun, 1 Apr 2007 00:01:48 +0000 (UTC)
Message-ID: <loom.20070401T015359-789@post.gmane.org>
References: <1712880100@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 68.60.176.179 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.3) Gecko/20070309 Firefox/2.0.0.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 
 
<devzero <at> web.de> writes:

> Whenever you want to test some new kernel (feature), you may put you main
system at risk, exactly know what
> you`re doing - or - use UserModeLinux.

Why won't qemu work better in this case? I generally keep a debian testing
installation on disk and when I compile a new kernel I just point qemu to load
it with the debian root fs. It's fast enough (even the kernel mode accelerator
module is GPLed now) and you don't need to mess around with your main system's
kernel. You can even test different arches - like both x86_64 and i386 on one
x64 box for example.

It doesn't work for any particular driver related testing but UML won't either.
And it won't benefit UML development but I don't know if that was your main
objective as opposed to general kernel experimentation and testing.

Parag

