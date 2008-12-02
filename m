Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbYLBPuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbYLBPuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYLBPuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:50:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbYLBPuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:50:08 -0500
Date: Tue, 2 Dec 2008 07:50:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc7
In-Reply-To: <20081202131442.42e7df48@varda>
Message-ID: <alpine.LFD.2.00.0812020748310.3256@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org> <20081202131442.42e7df48@varda>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2008, Alejandro Riveira Fernández wrote:
>  
>  All of this happens without the nvidia module loaded (not even compiled) 

It's definitely loaded according to your dmesg:

> [    0.000000] Linux version 2.6.28-rc7 (alex@varda) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11) ) #2 SMP PREEMPT Tue Dec 2 12:48:19 CET 2008
...
> [  101.744347] nvidia: module license 'NVIDIA' taints kernel.
> [  102.003828] nvidia 0000:01:00.0: PCI INT A -> GSI 25 (level, low) -> IRQ 25
> [  102.003838] nvidia 0000:01:00.0: setting latency timer to 64
> [  102.004747] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.06  Sat Nov  8 17:50:38 PST 2008

Hmm?? Can you double-check?

		Linus
