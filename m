Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbZEQTq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbZEQTq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 15:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbZEQTqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 15:46:16 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:38649 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbZEQTqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 15:46:15 -0400
Date: Sun, 17 May 2009 21:46:15 +0200
Message-Id: <720427516@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: david@lang.hm
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Where do we stand with the Xen patches?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+t+EGJ4my+uPwPb49eKxC4cUdx6+uv8eXZYtcTnpKUbrV9K
 aTmgeGDG1q+AI9Wi8bgiMBBomUTmYmFALmfuAhEMV7Q6xlSSnk=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> As in the past, my main worry is performance overhead of paravirt in
> >> general.
> >>
> >> The patches that dont affect any native kernel fast path are
> >> probably OK (but still pending final review).
> >>
> >> Regarding patches that do change the fastpath i'll do a round of
> >> measurements of CONFIG_PARAVIRT against !CONFIG_PARAVIRT kernels,
> >> and make up my mind based on that.
> >>
> >> You could accelerate this by sending some "perf stat" hard numbers
> >> to give us an idea about where we stand today.
> >>
> >> 	Ingo
> >
> > maybe this is iust a stupid comment (please forgive, i?m no advanced kernel
> > hacker), but can?t the code inserted by the patches and which changes the
> > fastpath just #IFDEF`ed at the critical offsets ?  (as building a dom0 kernel is
> > just another build target, isn`t it ?)
> 
> no, if dom0 is going to be widely deployed, it will be because the distros 
> turn on dom0 support by default. as a result any penalties due to xen 
> support will be felt by all users of those distros (even if they don't use 
> xen)
> 
> David Lang

so what?

print a huge warning on boot that running dom0 for xen may affect performance and that 
you should better run a normal kernel instead if you don`t use xen , and you`re done.

or is maintaining two different kernel packages a problem?

if so, instead of using IFDEF`s, can`t the critical path`s being generously circumvented 
by default, (if, else...), needing some dom0 kernel bootparam to be activated (i.e. use
the kernel as dom0 kernel) ?

or is this too short-sighted view of the things ?

regards
roland




______________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

