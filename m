Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbXD1Uip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbXD1Uip (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbXD1Uip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:38:45 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49868 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbXD1Uio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:38:44 -0400
Message-ID: <4633B0BB.6080600@zytor.com>
Date: Sat, 28 Apr 2007 13:38:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeff Garzik <jeff@garzik.org>, Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org> <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> The boot protocol change is in 2.6.21 for arch/i386.
> 
> HPA looked at it a while ago.
> 
> All it does is set a flag that tells a bootloader.
> "Hey. I can run when loaded a non-default address, and this is what
>  you have to align me to."
> 
> All relocation processing happens in the kernel itself.
> 
> So it is all pretty trivial.
> 

Indeed.  We *did* find some problems with Grub with the early versions,
those were addressed.

	-hpa
