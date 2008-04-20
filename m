Return-Path: <linux-kernel-owner+w=401wt.eu-S1759185AbYDTM1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbYDTM1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 08:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbYDTM1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 08:27:33 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:55297 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbYDTM1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 08:27:32 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Shawn Bohrer <shawn.bohrer@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
From: Andi Kleen <andi@firstfloor.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080418142934.38ce6bf4.akpm@linux-foundation.org>
	<20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop>
	<20080420080901.GF1595@cs181133002.pp.htv.fi>
	<20080420090623.7b173ef1@the-village.bc.nu>
	<20080420085104.GG1595@cs181133002.pp.htv.fi>
	<20080420103611.2c0d3519@the-village.bc.nu>
	<20080420104444.GI1595@cs181133002.pp.htv.fi>
Date: Sun, 20 Apr 2008 14:27:14 +0200
In-Reply-To: <20080420104444.GI1595@cs181133002.pp.htv.fi> (Adrian Bunk's message of "Sun, 20 Apr 2008 13:44:44 +0300")
Message-ID: <87y778aezh.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Apr 2008 12:20:26.0346 (UTC) FILETIME=[EA11ACA0:01C8A2E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:
>
> 6k is known to work, and there aren't many problems known with 4k.
>
> And from a QA point of view the only way of getting 4k thoroughly tested 

But you have to first ask why do you want 4k tested? Does it serve
any useful purpose in itself? I don't think so. Or you're saying
it's important to support 50k kernel threads on 32bit kernels?

-Andi
