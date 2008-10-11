Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbYJKIB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbYJKIB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 04:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbYJKIBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 04:01:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56605 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbYJKIBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 04:01:48 -0400
Date: Sat, 11 Oct 2008 10:08:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>,
       x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Update cacheline size on X86_GENERIC
Message-ID: <20081011080812.GA9880@one.firstfloor.org>
References: <20081009171453.GA15321@redhat.com> <200810101945.32111.nickpiggin@yahoo.com.au> <48EF2CE0.3080109@firstfloor.org> <200810111459.53306.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810111459.53306.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess there is a reasonable argument to not care about P4 so

I don't think it is. Ignoring old systems would be a mistake
and the wrong signal. One of Linux's forte over the competition 
was always to run reasonable on older systems too. 

There are millions and millions of P4s around.
And they're not that old, they're still shipping in fact.
And the point of GENERIC was to be a reasonable default on all
systems.

If you want to optimize for a specific CPU you're always free
to compile the kernel for that. But GENERIC should be really
GENERIC.

> much in today's GENERIC kernel. If it is worth around 1% on tpc
> on a more modern architecture, that is a pretty big motivation
> to change it too...

TPC is a extreme case, it is extremly cache bound.

Besides I suspect the TPC issue could be fixed with a minimal
tweaks without breaking other systems.

-Andi
-- 
ak@linux.intel.com

