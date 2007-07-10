Return-Path: <linux-kernel-owner+w=401wt.eu-S1763826AbXGJJWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763826AbXGJJWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbXGJJWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:22:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:5067 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763382AbXGJJWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:22:22 -0400
Date: Tue, 10 Jul 2007 11:22:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Pawel Dziepak <hryssta@gmail.com>
cc: "Renato S. Yamane" <renatoyamane@mandic.com.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: clocksource tsc unstable
In-Reply-To: <ec870ced0707091354y770e5a26y4493e2c935cb088e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707101121110.11053@fbirervta.pbzchgretzou.qr>
References: <46924CEB.7080108@mandic.com.br> <46925970.8080602@redhat.com> 
 <4692981E.20303@mandic.com.br> <ec870ced0707091354y770e5a26y4493e2c935cb088e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 9 2007 22:54, Pawel Dziepak wrote:

> As far as i know Pentium M processors have dynamically changed clock
> speed (ofc to save power). That's why kernel notice that TSC is
> unstable (it is indeed). On my Athlon 64 I have similar situation,
> because CPU frequency is dynamically changed.
> I don't think that there is an easy way to fix it (it is not even a
> bug), time-stamp counter is not perfect...

Also see http://lkml.org/lkml/2007/5/6/29

The TSC is supposed to tick at the CPU rate (unless it's a constant_tsc, 
see /proc/cpuinfo flags:), so on frequency change, this ought to happen. 
The kernel will automatically switch to something else. There's acpi_pm 
and, IIRC, pit.


	Jan
-- 
