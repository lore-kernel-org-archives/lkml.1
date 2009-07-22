Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbZGVOsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbZGVOsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZGVOsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:48:39 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:51107 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZGVOsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:48:38 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [patch] perf_counter tools: resurrect perf top annotation in a
 simple interactive form
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1248090981.18702.14.camel@marge.simson.net>
References: <1248090981.18702.14.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 16:49:50 +0200
Message-Id: <1248274190.27058.1530.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 13:56 +0200, Mike Galbraith wrote:
> Comments/suggestions/clue_bats welcome.
> 
> perf_counter tools: resurrect perf top annotation in a simple interactive form.
> 
> This patch allows the user to select any symbol in kernel space for source level
> annotation on the fly, switch between event counters and alter display variables.
> When symbol details are being displayed, stopping annotation reverts to normal.
> 
> This doesn't make top _fully_ interactive, you can only select among the events
> you started top with, ie it doesn't stop/start event counters etc.
> 
> known keys:
>         [d]     select display delay.
>         [e]     select display entries (lines).
>         [E]     select annotation event counter.
>         [f]     select normal display count filter.
>         [F]     select annotation display count filter (percentage).
>         [qQ]    quit.
>         [s]     select annotation symbol and start annotation.
>         [S]     stop annotation, revert to normal display.
>         [z]     toggle event count zeroing.

ok, so I tried this, but the screen updates overwrite this input
screen before I can read it ;-)

Would it be possible to make that wait on each-other?



