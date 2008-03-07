Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbYCGOqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbYCGOqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 09:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYCGOqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 09:46:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:58918 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbYCGOqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 09:46:22 -0500
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>
Message-Id: <36E7CB5B-4C3B-4ED3-BC46-A87BA92BC150@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Vitaly Bordug <vitb@kernel.crashing.org>
In-Reply-To: <20080306135330.6d5462d2@vitb.ru.mvista.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [POWERPC] 8xx: fix swap
Date: Fri, 7 Mar 2008 08:46:14 -0600
References: <20080306135330.6d5462d2@vitb.ru.mvista.com>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 6, 2008, at 4:53 AM, Vitaly Bordug wrote:

> This makes swap routines operate correctly on the ppc_8xx based  
> machines.
> Code has been revalidated on mpc885ads (8M sdram) with recent  
> kernel. Based
> on patch from Yuri Tikhonov <yur@emcraft.com> to do the same on arch/ 
> ppc
> instance.
>
> Recent kernel's size makes swap feature very important on low-memory  
> platforms,
> those are actually non-operable without it.
>
> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
> Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
> ---
>
> arch/powerpc/kernel/head_8xx.S      |   30 ++++++++++++++++++++++++++ 
> +++-
> include/asm-powerpc/pgtable-ppc32.h |    8 --------
> 2 files changed, 29 insertions(+), 9 deletions(-)

applied.

- k

