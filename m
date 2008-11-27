Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbYK0Tgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbYK0Tgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 14:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYK0TgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 14:36:22 -0500
Received: from www.tglx.de ([62.245.132.106]:37562 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYK0TgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 14:36:21 -0500
Date: Thu, 27 Nov 2008 20:35:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@gmail.com
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, sfr@canb.auug.org.au
Subject: Re: [patch 02/24] perfmon: base code
In-Reply-To: <7c86c4470811271051g66669197qb6b5fd39961668a9@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811272031540.3325@localhost.localdomain>
References: <492d0bd8.11435e0a.1686.ffff8801@mx.google.com>  <alpine.LFD.2.00.0811271638350.3325@localhost.localdomain>  <7c86c4470811270947q585cba5vf8bdb875962a1856@mail.gmail.com>  <alpine.LFD.2.00.0811271858300.3325@localhost.localdomain>
 <7c86c4470811271051g66669197qb6b5fd39961668a9@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane,

On Thu, 27 Nov 2008, stephane eranian wrote:

> >> session is independent of each other. You can therefore measure different
> >> things on different CPUs. Reservation is thus done independently for each
> >> CPU, therefore we need a cpu bitmask  to track allocation.
> >
> > Ok. Question: if you do a one CPU wide session with perfom, can you
> > still do thread monitoring on the same CPU ?
> >
> No. They are currently mutually exclusive.
> 
> > If no, what prevents that a monitored thread is migrated to such a CPU ?
> >
> Nothing. AND you don't want to change affinity because you are monitoring.
> So the current restriction is that cpu-wide and per-thread are
> mutually exclusive.

And how is this achieved ? Currently there seems nothing which
prevents a per-thread vs. cpu-wide monitoring.

Thanks,

	tglx
