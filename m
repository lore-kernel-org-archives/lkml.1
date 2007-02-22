Return-Path: <linux-kernel-owner+w=401wt.eu-S1751382AbXBVR3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbXBVR3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbXBVR3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:29:10 -0500
Received: from ppsw-2.csi.cam.ac.uk ([131.111.8.132]:47013 "EHLO
	ppsw-2.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbXBVR3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:29:09 -0500
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Mime-Version: 1.0 (Apple Message framework v752.2)
In-Reply-To: <Prayer.1.0.18.0702211050410.32479@hermes-1.csi.cam.ac.uk>
References: <Prayer.1.0.18.0702211050410.32479@hermes-1.csi.cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <2B9DC3C2-6A3B-4BFF-B25D-ADFB94AC4390@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: 2.6.21-rc1 NFS build error on x86/ARM with modular IPV6
Date: Thu, 22 Feb 2007 17:28:43 +0000
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NB: I'm not subscribed so please CC me in any reply! Thanks...

Updated bugzilla with x86 defconfig demonstrating similar breakage.
http://bugzilla.kernel.org/show_bug.cgi?id=8050

Both issues seem to demonstrate a problem with built-in NFS and  
modular IPV6 together.

Michael-Luke Jones

On 21 Feb 2007, at 10:50, M.L. Jones wrote:

> Hi there,
>
> Just attempted a build of vanilla 2.6.21-rc1 and got a failure with  
> our usual defconfig. Notably, we build IPV6 support as modular -  
> this seems to be the source of the problem.
>
> If any other info is required, please ask.
>
> Thanks for your help,
>
> Michael-Luke Jones
> NSLU2-Linux Core Team
>
> ==Error==
>  GEN     .version
>  CHK     include/linux/compile.h
>  UPD     include/linux/compile.h
>  CC      init/version.o
>  LD      init/built-in.o
>  LD      .tmp_vmlinux1
> net/built-in.o: In function `svc_udp_recvfrom':
> sysctl_net.c:(.text+0x79fb4): undefined reference to  
> `__ipv6_addr_type'
> make[1]: *** [.tmp_vmlinux1] Error 1

