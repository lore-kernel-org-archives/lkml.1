Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbYLMOqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbYLMOqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 09:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbYLMOqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 09:46:07 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:51427 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYLMOqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 09:46:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=T4KjCW1gDyQcMe8xYuyhwJjTb7sgZXbJU/fWqO0op7YPERZlhufR0KTA9HSyHbigAx
         xxyPieL7ICFRxNazusMXz5DURcxlpVwgFlQJfcQwLvxpVWQJeB9xnW2RMcdaDpmtm4Hx
         kjgvGx9/HrMDPMJGiRTCeiVG9uYFmOiLpda3c=
Message-ID: <c62985530812130646r6bcdf424o752f16458dd22914@mail.gmail.com>
Date: Sat, 13 Dec 2008 15:46:03 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Steven Rostedt" <srostedt@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Alexander van Heukelum" <heukelum@fastmail.fm>
In-Reply-To: <20081213082054.GA7559@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212184136.GB14192@localhost>
	 <1229113167.32623.12.camel@localhost.localdomain>
	 <20081212204724.GA26194@localhost>
	 <alpine.DEB.1.10.0812121552360.19351@gandalf.stny.rr.com>
	 <20081212205729.GA28554@localhost>
	 <alpine.DEB.1.10.0812121620520.19351@gandalf.stny.rr.com>
	 <20081212213538.GA731@localhost>
	 <alpine.DEB.1.10.0812121655090.19351@gandalf.stny.rr.com>
	 <20081213082054.GA7559@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/13 Cyrill Gorcunov <gorcunov@gmail.com>:
> [Steven Rostedt - Fri, Dec 12, 2008 at 04:56:47PM -0500]
> ...
> | > Steve, here is how it could look like:
> | > (I liked first proposal more :)
> |
> | I see the confusion. In ftrace.h the function graph tracer config is not
> | inside CONFIG_FUNCTION_TRACER, even though it is dependent on it (or
> | was). OK, just do your first proposal then.
> |
> | -- Steve
> |
>
> ok, I sent it yesterday as
>
>        http://lkml.org/lkml/2008/12/12/301
>        [PATCH] x86: entry_64 - introduce FTRACE_ frame macro v2
>
> Ingo, will you pick it up?
>
>                - Cyrill -
>

Hi,

Looks good and clarify the asm bits.

I wonder if the function_graph_tracer should continue to necessarily
depend on the function tracer.
It was more simplier to do so but perhaps that could be avoided with
small modifications.
