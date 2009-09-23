Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZIWJPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZIWJPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZIWJPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:15:05 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:6196 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZIWJPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:15:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=nx8hsMjxkqrB0svj7koA5p8pksGYvLW+oLTxRtuOuWKUATh8gEx+vap/IDOTi4Nkpw
         g9tmpifAHAe/p6fTEuw8ec+ZolgJflCOeIb1/Gd8Y7MO+GxmbooXKqxKWKI3YL2Djb+c
         Q44VcoTYVrsJyHyqruyWgcr4jzMBIyX86/of4=
MIME-Version: 1.0
In-Reply-To: <aa79d98a0909230148j47232382oe28c6d88eef181c4@mail.gmail.com>
References: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com>
	 <20090922212453.GB6062@nowhere> <1253686585.7695.84.camel@twins>
	 <20090923073253.GA18022@elte.hu> <20090923074028.GA3078@elte.hu>
	 <aa79d98a0909230044q3548cf0bjda62e05e0400edd6@mail.gmail.com>
	 <aa79d98a0909230148j47232382oe28c6d88eef181c4@mail.gmail.com>
Date: Wed, 23 Sep 2009 10:15:07 +0100
X-Google-Sender-Auth: 2ab58a6bc9a95fe6
Message-ID: <7863dc4c0909230215u2fed3edciec84f93f24d3ae1@mail.gmail.com>
Subject: Re: perf sched record hangs machine
From: Chris Malley <mail@chrismalley.co.uk>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/23 Cyrill Gorcunov <gorcunov@gmail.com>:
>
> Btw, meanwhile Chris may try to pass lapic boot-option in attempt to
> reenable apic via msr registers. Also (iirc) i feel we may be hiding
> errors if complete noop apic would be used since i belive we need to
> check out under which condition a particular operation is called and
> when apic is disabled it's mean we're switched to UP mode and
> inter-cpu interrupts are under suspicion too. Will take a look during
> ~6 hours ;)
>

Hi Cyrill

Heh, yes that just occurred to me as well.  With the lapic boot option
I can't reproduce the problem, and get a good recording every time.
Don't know why the BIOS had disabled it (can't see any specific
option).

cheers
Chris
