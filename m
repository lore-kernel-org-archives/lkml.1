Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbYJXRlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbYJXRlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYJXRlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:41:17 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:54171 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYJXRlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:41:16 -0400
Message-ID: <4902086E.6030900@freescale.com>
Date: Fri, 24 Oct 2008 12:39:58 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Chris Snook <csnook@redhat.com>,
       LinuxPPC-dev list <linuxppc-dev@ozlabs.org>, tglx@linutronix.de,
       linux-kernel Kernel <linux-kernel@vger.kernel.org>, maxk@qualcomm.com
Subject: Re: default IRQ affinity change in v2.6.27 (breaking several SMP
 PPC	based systems)
References: <4E3CD4D5-FC1B-40BF-A776-C612B95806B8@kernel.crashing.org>	<4901E6FB.4070200@redhat.com>	<36A821E7-7F37-42AF-9A05-7205FCBF89EE@kernel.crashing.org>	<4901F31E.9040007@redhat.com> <5967704E-0117-46B8-8505-6A002502C38C@kernel.crashing.org>
In-Reply-To: <5967704E-0117-46B8-8505-6A002502C38C@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> So why not just have x86 startup code set irq_default_affinity = 
> CPU_MASK_ALL than?

That doesn't really solve the problem, as a user could still manually 
set an invalid affinity.  The MPIC driver should reduce the affinity 
itself to what the hardware can handle.

-Scott
