Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbYCZKF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbYCZKF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbYCZKFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:05:51 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:48567
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbYCZKFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:05:50 -0400
Message-ID: <47EA1EF9.9080602@qumranet.com>
Date: Wed, 26 Mar 2008 12:01:29 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Glauber Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       mingo@elte.hu, tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com
Subject: Re: [PATCH 0/20] dma_ops for i386
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
In-Reply-To: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (firebolt.argo.co.il [0.0.0.0]); Wed, 26 Mar 2008 12:01:29 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> Hello,
>
> Here there is a series of 20 patches that lays the foundations for
> using dma_ops in i386 in the very same way x86_64, as well as many other
> architectures already do.
>
> The functions themselves for i386 are placed in a pci-base_32.c, but just
> a few among them are actually implemented. Most were no-ops anyway.
>
>   

I see the headers are unified, but the .c files are duplicated.  I 
presume unifying the implementation is deferred to later patches?


> The motivation for that is the ongoing work for pci-passthrough in KVM.
> So ingo, avi, what do you think it's the best way to handle these patches through?
>   

x86.git.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

