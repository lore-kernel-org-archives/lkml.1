Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbXLPXsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbXLPXsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 18:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932799AbXLPXs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 18:48:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55345 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760225AbXLPXs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 18:48:28 -0500
Message-ID: <4765B930.8010208@zytor.com>
Date: Sun, 16 Dec 2007 15:48:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/4] x86: Final unification of local_{32|64}.h
References: <1197806669.3749.44.camel@brick> <20071216153158.GA891@elte.hu>	 <4765AB32.9040608@zytor.com> <1197848331.3749.86.camel@brick>
In-Reply-To: <1197848331.3749.86.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> 
> Do you have a stylistic preference between these two options:
> 
> Option 1) Rely on CPP string constant concatenation
> 
> // possibly include trailing space here to avoid remembering
> // leading space on the register names
> # define _ASM_INC "incl" 
> 
> static inline void local_inc(local_t *l)
> {
> 	__asm__ __volatile__(
> 		_ASM_INC " %0"
> 		:"+m" (l->a.counter));
> }
> 

This is what I have used up to this point, except including the space in 
the macro:

#define _ASM_INC " incl "

	_ASM_INC "%0"

	-hpa
