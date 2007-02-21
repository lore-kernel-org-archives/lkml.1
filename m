Return-Path: <linux-kernel-owner+w=401wt.eu-S1751332AbXBUTCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbXBUTCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbXBUTCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:02:15 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:48148 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbXBUTCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:02:14 -0500
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Mime-Version: 1.0 (Apple Message framework v752.2)
In-Reply-To: <BA89D4F9-7D44-49C6-94EC-0AFC8B7A8CEC@cam.ac.uk>
References: <Prayer.1.0.18.0702211050410.32479@hermes-1.csi.cam.ac.uk> <BA89D4F9-7D44-49C6-94EC-0AFC8B7A8CEC@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <DF94C2A9-4E30-4A4A-9269-C6F380EC9B35@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: 2.6.21-rc1 build error on ARM with modular IPV6
Date: Wed, 21 Feb 2007 19:01:39 +0000
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel Bugzilla bug created:
http://bugzilla.kernel.org/show_bug.cgi?id=8050

Michael-Luke Jones

On 21 Feb 2007, at 14:36, Michael-Luke Jones wrote:

> Apologies for brain failure, below should read 2.6.21-rc1.
>
> Everything else should be correct.
>
> Michael-Luke Jones
>
> On 21 Feb 2007, at 10:50, M.L. Jones wrote:
>
>> NB: I'm not subscribed so please CC me in any reply! Thanks...
>>
>> Hi there,
>>
>> Just attempted a build of vanilla 2.6.20-rc1 and got a failure  
>> with our usual defconfig. Notably, we build IPV6 support as  
>> modular - this seems to be the source of the problem.
>>
>> If any other info is required, please ask.
>>
>> Thanks for your help,
>>
>> Michael-Luke Jones
>> NSLU2-Linux Core Team
>>
>> ==Error==
>>  GEN     .version
>>  CHK     include/linux/compile.h
>>  UPD     include/linux/compile.h
>>  CC      init/version.o
>>  LD      init/built-in.o
>>  LD      .tmp_vmlinux1
>> net/built-in.o: In function `svc_udp_recvfrom':
>> sysctl_net.c:(.text+0x79fb4): undefined reference to  
>> `__ipv6_addr_type'
>> make[1]: *** [.tmp_vmlinux1] Error 1
>>

