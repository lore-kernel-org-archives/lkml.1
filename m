Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXLPX77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXLPX77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 18:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759499AbXLPX7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 18:59:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:46477 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195AbXLPX7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 18:59:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MaCSmPtaSz2vU2WOur1OqgPHT2bQYqDzfQE3nWGY/1ZhCJ8GqAYR+7rfN6eeF5HnFUttENYaX3bixc2WaXgY53r1F9l/lOpDwaeYFkiLUkCuRR6WcM6etfDjaQGy750R8WpH+dWXJ6kUWx+LE/3le0gGNGeLuFr8UV6T4EYs6FU=
Subject: Re: [PATCH 4/4] x86: Final unification of local_{32|64}.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4765B930.8010208@zytor.com>
References: <1197806669.3749.44.camel@brick> <20071216153158.GA891@elte.hu>
	 <4765AB32.9040608@zytor.com> <1197848331.3749.86.camel@brick>
	 <4765B930.8010208@zytor.com>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 15:59:51 -0800
Message-Id: <1197849591.3749.88.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-12-16 at 15:48 -0800, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> > 
> > Do you have a stylistic preference between these two options:
> > 
> > Option 1) Rely on CPP string constant concatenation
> > 
> > // possibly include trailing space here to avoid remembering
> > // leading space on the register names
> > # define _ASM_INC "incl" 
> > 
> > static inline void local_inc(local_t *l)
> > {
> > 	__asm__ __volatile__(
> > 		_ASM_INC " %0"
> > 		:"+m" (l->a.counter));
> > }
> > 
> 
> This is what I have used up to this point, except including the space in 
> the macro:
> 
> #define _ASM_INC " incl "
> 
> 	_ASM_INC "%0"

Not sure if you were just tossing a space on the end of my example,
but do you also put a leading space on the " incl " in addition to
the trailing space?

Harvey

