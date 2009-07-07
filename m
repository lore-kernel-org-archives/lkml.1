Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbZGGOge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbZGGOge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758425AbZGGOfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:35:07 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:58149 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758472AbZGGOfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:35:04 -0400
X-SourceIP: 213.93.53.227
Subject: Re: 'config EVENT_PROFILE' - how does it ever work?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <11231.1246973627@turing-police.cc.vt.edu>
References: <11231.1246973627@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 16:34:55 +0200
Message-Id: <1246977295.8143.319.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 09:33 -0400, Valdis.Kletnieks@vt.edu wrote:
> Peter - where do you prefer your e-mail?  MAINTAINERS for 'perf' gives this
> chello.nl address, but peterz@infradead.org for other stuff? Sending to both
> just in case...

either work, they end up in the same inbox ;-)

> Found this while trying to figure out why there was a one-entry menu
> for performance counters.
> 
> Commit e077df4f adds to init/Kconfig this code:
> 
> config EVENT_PROFILE
>         bool "Tracepoint profile sources"
>         depends on PERF_COUNTERS && EVENT_TRACER
>         default y
> 
> But there's no other usage of EVENT_TRACER I can find other than a lot
> of 'EVENT_TRACER is not set' entries in defconfigs.  Is this an actual bug,
> or did I lose the plot someplace?

It used to work at some point in the past, but then I think it bitrotted
a bit with the tracer changes. I think Jason Baron posted a few patches
yesterday that fixed it all up and made it work nicely again.

http://lkml.org/lkml/2009/7/6/313

