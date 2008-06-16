Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbYFPQcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbYFPQcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 12:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757013AbYFPQbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 12:31:51 -0400
Received: from mail.vyatta.com ([216.93.170.194]:39400 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756705AbYFPQbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 12:31:48 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.034
Date: Mon, 16 Jun 2008 09:31:42 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
       David Newall <davidn@davidnewall.com>, Jeff Garzik <jgarzik@pobox.com>,
       netdev@vger.kernel.org, Trivial Patch Monkey <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] 8139too: clean up spaces and TABs
Message-ID: <20080616093142.078f5528@extreme>
In-Reply-To: <485681BA.4060808@s5r6.in-berlin.de>
References: <4853BB62.1060109@freemail.hu>
	<4853C8AD.9020407@s5r6.in-berlin.de>
	<48541165.7050304@freemail.hu>
	<485421C1.8010102@s5r6.in-berlin.de>
	<4854C9BF.8040900@freemail.hu>
	<485681BA.4060808@s5r6.in-berlin.de>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 17:07:38 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Németh Márton wrote:
> > I have chosen the checkpatch.pl's output to compare the
> > whether the old and the new code are better or not. Maybe that was a mistake.
> 
> Well, running checkpatch on source files (rather than patches) and
> fixing the files up according to checkpatch's output and own good
> judgement has two uses:
>   - bring new unmerged code into shape before submission,
>   - bring older mainline code into the canonical form as a basis
>     for further work.  You certainly saw how lots and lots of such
>     checkpatch-assisted cleanups went into arch/x86.  That's because
>     they were found useful for the work on unifying the two x86
>     architecture subtrees.
> So, a coding style rework has its use even on legacy code if people have
> plans with the code.  But keep in mind that (a) the whitespace rules
> aren't hard and universally agreed upon rules, (b) coding style has a
> number of other aspects of arguably greater importance than whitespace
> style, like proper modularization, good choices of names, use of common
> idioms and APIs instead of own inventions, and so on.

There is no point in doing this kind of checkpatch cleanup on its own.
It is worth doing more serious style work and rewriting of older drivers,
in the areas where other work needs to be done. Please work on drivers
that are ugly old vendor code, and/or you can find someone with the hardware
to test it.
