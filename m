Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbZJSC6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbZJSC6E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 22:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755742AbZJSC6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 22:58:03 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46433 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbZJSC6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 22:58:01 -0400
Subject: Re: nfs mount fail
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091019114339.4b67d947@infradead.org>
References: <86802c440910171825j22556a4bofbf0bd6cd134d53c@mail.gmail.com>
	 <84144f020910181935q4aed9f0dx7a8a149d8b8743c7@mail.gmail.com>
	 <20091019114339.4b67d947@infradead.org>
Date: Mon, 19 Oct 2009 05:58:00 +0300
Message-Id: <1255921080.839.2.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 11:43 +0900, Arjan van de Ven wrote:
> On Mon, 19 Oct 2009 05:35:20 +0300
> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > >
> > > [  278.734149] ------------[ cut here ]------------
> > > [  278.739620] kernel BUG at mm/slub.c:2969!
> > 
> > So this means that someone is passing a pointer to kfree() that did
> > not come from kmalloc(). Which tree are you testing?
> 
> > > [  278.770030] Pid: 2594, comm: rpciod/0 Not tainted
> > > 2.6.32-rc5-tip-01483-ga166936-dirty #651
> 
> some evil person decided to put the exact kernel tree/version in the
> oops output ;-)

Oh, right. Ingo, Yinghai says Linus' tree is fine so any ideas why this
shows up in -tip? Also it seems we've had a similar bug before:

  http://lkml.org/lkml/2009/4/2/698

Hmmh?

			Pekka

