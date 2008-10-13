Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYJMUaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYJMUaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbYJMU34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:29:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44484 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbYJMU34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:29:56 -0400
Message-ID: <48F3AFBF.3040201@firstfloor.org>
Date: Mon, 13 Oct 2008 22:29:51 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.14 (X11/20060911)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Please pull arch perfmon update
References: <20080929235253.GA31074@one.firstfloor.org> <20081013183556.GD23557@erda.amd.com>
In-Reply-To: <20081013183556.GD23557@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> I applied your patches to the x86-oprofile-for-tip branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git

Will that still make 2.6.28?

> I added a follow on patch (446223f) on branch arch-perfmon that

I didn't do that intentionally because it's called too late.
The function really has to be called early, so that the fallback
works.

> There is one question to patch "oprofile: discover counters for op
> ppro too". arch_perfmon_setup_counters() is actually never called for
> ppro, so there is no code that changes the numbers in
> op_ppro_spec. The patch as it is has no effect (except then loading
> additional module code).

Ah true, i must have deleted one hunk too much while refactoring.
It's ok to drop this patch for now.

-Andi

