Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbYEGOZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbYEGOZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbYEGOYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:24:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39252 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471AbYEGOYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:24:53 -0400
Date: Wed, 7 May 2008 07:24:31 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26, PAT and AMD family 6
Message-ID: <20080507072431.30abefae@infradead.org>
In-Reply-To: <4821B801.5030508@keyaccess.nl>
References: <48210A71.1060409@keyaccess.nl>
	<86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>
	<4821A7E2.6080101@keyaccess.nl>
	<20080507064259.36deb978@infradead.org>
	<4821B801.5030508@keyaccess.nl>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 16:09:05 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:


[as for which cpus]

The errata docs have these errata, at least for Intel I know they're
there. We can add back older cpus over time, but again.. think of it as
a risk/reward thing ;( Right now, breaking all kinds of well working
older systems without benefits on the upside..... that's not very
popular on lkml. Once PAT is rock solid I hope we can relax this check
greatly...

> A blacklist would be a better idea I feel, but in ANY case I think
> it's really bad form to clear the feature flag. They are provided by
> hardware; if arch/x86/mm/pat.c won't risk running except on a select
> few tested models, whatever, but my /proc/cpuinfo shouldn't be lying
> to me.

we filter those for all kinds of things already, sorry.
What good is showing "pat" if "pat" isn't deemed usable (yet)????
Now *that* is deception :)
> 
> Rene.
