Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbZJHOOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbZJHOOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 10:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758068AbZJHOOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 10:14:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:57026 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758024AbZJHOOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 10:14:03 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18AAMhDIeUArLh/791WT0vz1DCL3vGrio08v0Hcu6
	6unMrCby196zT1
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
From: Mike Galbraith <efault@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <20091008064041.67219b13@infradead.org>
References: <200910051500.55875.elendil@planet.nl>
	 <200910061749.02805.elendil@planet.nl>
	 <200910071910.53907.elendil@planet.nl>
	 <200910072034.57511.elendil@planet.nl>
	 <1254974743.7797.21.camel@marge.simson.net>
	 <20091008064041.67219b13@infradead.org>
Content-Type: text/plain
Date: Thu, 08 Oct 2009 16:13:06 +0200
Message-Id: <1255011186.7294.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 06:40 -0700, Arjan van de Ven wrote:
> On Thu, 08 Oct 2009 06:05:43 +0200
> Mike Galbraith <efault@gmx.de> wrote:

> > OK, I see latencytop spikes here on an idle box too, to the tune of up
> > to a _second_.  Booting with nohz=off seems to have cured it.
> 
> interesting..
> 
> 
> by chance, does this patch fix it ?

I haven't seen incredible yet, but with idle box, have seen > 200ms, so
would say no.

	-Mike

