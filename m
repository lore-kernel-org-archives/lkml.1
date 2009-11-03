Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbZKCTW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbZKCTW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbZKCTW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:22:56 -0500
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:59101 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201AbZKCTWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:22:55 -0500
From: Frans Pop <elendil@planet.nl>
To: Reg Clemens <reg@dwf.com>
Subject: Re: Can build 2.6.31.5 on one P4 but not another.
Date: Tue, 3 Nov 2009 20:22:58 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200911031815.nA3IFCe6017661@deneb.dwf.com>
In-reply-To: <200911031815.nA3IFCe6017661@deneb.dwf.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911032022.59466.elendil@planet.nl>
X-OriginalArrivalTime: 03 Nov 2009 19:22:59.0412 (UTC) FILETIME=[0DD40940:01CA5CBB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reg Clemens wrote:
> Can someone explain this to me.
> I can build 2.6.31.5 on one of my Pentium 4's with no problems,
> it boots and runs.
> 
> On a second P4, the build fails (compile works, load fails) with
> comments about undefined references to:
> sleep_on_common
> and  __up
>
> These appear in sched.c and  semaphore.c.

Are you using identical configs for both machines or not?

Are you sure both machines really have the same kernel source?

Have you tried if a 'make mrproper' makes a difference (normally it should 
not)?

Do both machines have the same build environment (gcc version, binutils, 
etc)?

If you need additional help, please post the exact error messages and the 
kernel config for the failing machine.

Cheers,
FJP

P.S. Why are you building the kernels on two machines instead of doing the 
builds on one machine and then copying and installing a build for the 
second? That could save a lot of build time, even if you don't use 
identical configs.
