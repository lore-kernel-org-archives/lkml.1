Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab0BRBN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:13:26 -0500
Received: from snt0-omc2-s32.snt0.hotmail.com ([65.55.90.107]:58834 "EHLO
	snt0-omc2-s32.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752509Ab0BRBNY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:13:24 -0500
Message-ID: <SNT125-W43CEC942D4248B42CA7B1DC3470@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@zytor.com>
CC: <luca@luca-barbieri.com>, <mingo@elte.hu>, <a.p.zijlstra@chello.nl>,
       <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 10/10] x86-32: panic on !CX8 && XMM
Date: Wed, 17 Feb 2010 17:13:23 -0800
Importance: Normal
In-Reply-To: <4B7C7EB3.6000202@zytor.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
 <1266406962-17463-11-git-send-email-luca@luca-barbieri.com>,<4B7C6FC8.7090107@zytor.com>
 <SNT125-W19438E1E5A7FB2F02097DEC3480@phx.gbl>,<4B7C7EB3.6000202@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 18 Feb 2010 01:13:23.0842 (UTC) FILETIME=[9126F620:01CAB037]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Also, don't forget the NT4 CX8 bug with non-Intel/AMD/Cyrix vendors:
>> http://www.geoffchappell.com/studies/windows/km/cpu/cx8.htm
>> If a processor support SSE (or PAE or MMX for that matter), you can pretty much assume CX8 exists even if the feature bit is cleared because of this bug.
>>
>
> Those kinds of things we *also* deal with by adjusting the CPU features
> in the detection code.
 
And in fact, the Linux setup code already has code similar to the code used in XP to disable this NT4 workaround.

Yuhong Bao
 		 	   		   		 	   		  
_________________________________________________________________
Hotmail: Powerful Free email with security by Microsoft.
http://clk.atdmt.com/GBL/go/201469230/direct/01/