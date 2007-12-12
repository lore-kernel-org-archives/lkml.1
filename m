Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbXLLXJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbXLLXJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 18:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXLLXJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 18:09:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54947 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbXLLXJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 18:09:30 -0500
Message-ID: <47606A00.2080108@zytor.com>
Date: Wed, 12 Dec 2007 15:08:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Remove 'e' from kprope structure members
References: <1197421087.8761.27.camel@brick>  <47602776.10408@zytor.com> <1197487642.21291.1.camel@brick> <47606804.1010709@goop.org>
In-Reply-To: <47606804.1010709@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Harvey Harrison wrote:
>> Some kprobe structure members had a superfluous e in their
>> name.
>>
>> eflags -> flags
>> esp -> sp
>>   
> 
> eflags and esp are the actual machine register names (at least in
> 32-bit), and therefore more distinctive than just "flags". 
> 
> If this is in preparation for a unification then OK, but I disagree if
> not (and technically 64-bit should be using rsp/rflags).
> 

Yes, that's the whole point (unification.)

	-hpa

