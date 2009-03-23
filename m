Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbZCWGFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbZCWGFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 02:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZCWGFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 02:05:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:52820 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbZCWGFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 02:05:31 -0400
Subject: Re: [Bug #12792] 2.6.29-rc6-git4 boot failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <49C7186F.3050403@in.ibm.com>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
	 <l8NZ2a3iQtG.A.6EB.JaTxJB@chimera> <1237758581.25062.677.camel@pasglop>
	 <49C7186F.3050403@in.ibm.com>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 17:05:07 +1100
Message-Id: <1237788307.25062.686.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I narrowed it down to 2.6.28-git2(Boots) while 2.6.28-git4(fails to boot).
> I could not boot test 2.6.28-git3 as i ran into kernel compilation issues.
> 
> Here is the error message i got when i tried compiling 2.6.28-git3.
> 
>   LD      vmlinux.o
> ld: dynreloc miscount for kernel/built-in.o, section .opd
> ld: can not edit opd Bad value
> 
> I think the above one was some tool chain related issue.
> 
> I don't know how to git bisect using these two releases (2.6.28-git2/2.6.28-git4).
> I guess that is not possible since there are no commit tags for these releases.
> But i could be wrong.
> 
> Is there anything else that i could try out to find a solution for this ?
> The machine in question is a Power Mac G5 running Ubuntu Hardy with a
> PPC970, altivec supported CPU(2).
> 
> For the record i can still recreate this issue with 2.6.29-rc8-git6.

Strange I have such a powermac here and haven't seen that problem... let
me dig a bit.

Cheers,
Ben.


