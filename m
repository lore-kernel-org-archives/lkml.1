Return-Path: <linux-kernel-owner+w=401wt.eu-S1757608AbZFJTTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbZFJTTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbZFJTTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:19:35 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:45927 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbZFJTTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:19:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uyrSzKV3plAbBP5P+zHDnxvSd6FytljGdZs8Ure/L4tqL0xfchKBDMCVKD8t2uVtEN
         /RY/lsBp22/YTeuarNbCni9Jb3ljJykRmK0FX10Us7XemmtGFZGFg+4kK8tIuJjvSIGE
         4+xRjRTSKbH+s08tHRA0dWaftTXPK6nIoqbQE=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0906101511070.30552@gandalf.stny.rr.com>
References: <1244623722-6325-1-git-send-email-vapier@gentoo.org> 
	<1244623722-6325-2-git-send-email-vapier@gentoo.org> <alpine.DEB.2.00.0906101303560.30552@gandalf.stny.rr.com> 
	<8bd0f97a0906101131m2fc21f75uc174631150897e5e@mail.gmail.com> 
	<alpine.DEB.2.00.0906101441410.30552@gandalf.stny.rr.com> 
	<8bd0f97a0906101207s3eb36ccbp7baa631a941b9b0f@mail.gmail.com> 
	<alpine.DEB.2.00.0906101511070.30552@gandalf.stny.rr.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 10 Jun 2009 15:19:17 -0400
Message-ID: <8bd0f97a0906101219r7a7fcbdfqc0c45c9c97210d1a@mail.gmail.com>
Subject: Re: [PATCH 2/2] ftrace: document basic ftracer/ftracer graph needs
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 15:11, Steven Rostedt wrote:
> On Wed, 10 Jun 2009, Mike Frysinger wrote:
>> On Wed, Jun 10, 2009 at 14:45, Steven Rostedt wrote:
>> > If there's a HAVE_XXX in Kconfig that I want to see how to implement it, I
>> > go off and do 'grep -r XXX Documentation'.
>>
>> i look for the source of the define because ive given up on the
>> Documentation actually being relevant
>
> And you think documentation in Kconfig will be updated??

i didnt mean *just* Kconfig, but funny enough, the Kconfig for
HAVE_FUNCTION_TRACE_MCOUNT_TEST had the most relevant information.
all other places were #ifdef with no meaning.  and the existing
x86/ppc/sh ports of ftrace are devoid of any comments let alone useful
ones, as is the core ftrace code wrt the arch pieces it relies on.
the absolute dearth of ftrace documentation for arch porters is
ridiculous.
-mike
