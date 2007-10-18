Return-Path: <linux-kernel-owner+w=401wt.eu-S1762656AbXJRNWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762656AbXJRNWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 09:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756154AbXJRNWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:22:17 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:44163 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbXJRNWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:22:16 -0400
Message-ID: <47175D9D.50802@linux.vnet.ibm.com>
Date: Thu, 18 Oct 2007 18:50:29 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, imsudhirkumar@gmail.com
Subject: Re: 2.6.23-mm1 - powerpc - Build fails at arch/powerpc/boot/inflate.o
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <47174C49.5050308@linux.vnet.ibm.com> <18199.20538.594159.877930@cargo.ozlabs.ibm.com>
In-Reply-To: <18199.20538.594159.877930@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Kamalesh Babulal writes:
> 
>> The kernel build fails on the power box
>>
>>   INSTALL vdso64.so
>>
>>   INSTALL vdso32.so
>>
>>   BOOTCC  arch/powerpc/boot/inflate.o
>>
>> arch/powerpc/boot/inflate.c:920:19: error: errno.h: No such file or directory
> 
> This problem is fixed by d4faaecbcc6d9ea4f7c05f6de6af98e2336a4afb in
> Linus' tree.
> 
> Paul.
> -
Hi Paul,
Thanks, we tried it out over the 2.6.23-mm1 and the patch fixes the build failure.

-- 
Thanks & Regards,
Kamalesh Babulal,
