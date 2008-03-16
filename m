Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbYCPLLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbYCPLLX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 07:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYCPLLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 07:11:14 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:35521
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYCPLLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 07:11:13 -0400
Message-ID: <47DD004C.7010108@qumranet.com>
Date: Sun, 16 Mar 2008 13:11:08 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       kvm-devel@lists.sourceforge.net, tglx <tglx@linutronix.de>,
       mingo <mingo@redhat.com>, hpa <hpa@zytor.com>
Subject: Re: [PATCH] x86: kvmclock needs to include apic.h
References: <20080314112457.a7bc2358.randy.dunlap@oracle.com>
In-Reply-To: <20080314112457.a7bc2358.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> kvmclock needs to #include apic.h to prevent a build error:
>
> next-20080314/arch/x86/kernel/kvmclock.c:142: error: implicit declaration of function 'setup_secondary_APIC_clock'
> elan1.out:make[2]: *** [arch/x86/kernel/kvmclock.o] Error 1
>
>   

Applied, thanks.


-- 
error compiling committee.c: too many arguments to function

