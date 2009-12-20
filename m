Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbZLTRWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbZLTRWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbZLTRWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:22:13 -0500
Received: from mail.perches.com ([173.55.12.10]:1311 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbZLTRWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:22:12 -0500
Subject: Re: sched: restore sanity
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20091220144925.GA19608@elte.hu>
References: <1261315437.4314.6.camel@laptop>
	 <20091220144925.GA19608@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 09:22:10 -0800
Message-ID: <1261329730.30458.178.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 15:49 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> > Revert the braindead pr_* crap.
> > it's dumb and causes stupid "sched: " strings all over the place.
> > -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > -
> >  #include <linux/mm.h>
> >  #include <linux/module.h>
> >  #include <linux/nmi.h>
> 
> that's all that we need to remove i suspect, to get rid of the stupid 
> prefixes.

True.

