Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbZGJJkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbZGJJkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZGJJk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:40:28 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48139 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZGJJk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:40:28 -0400
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already
 using mudflap
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-kernel@vger.kernel.org, vegard.nossum@gmail.com, fche@redhat.com,
       cl@linux-foundation.org
In-Reply-To: <20090710092921.GF14666@wotan.suse.de>
References: <1247156020.27671.40.camel@debian-nb>
	 <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com>
	 <20090710084745.GA26752@elte.hu> <1247215920.32044.3.camel@penberg-laptop>
	 <20090710090351.GD14666@wotan.suse.de>
	 <1247217263.771.8.camel@penberg-laptop>
	 <20090710092921.GF14666@wotan.suse.de>
Date: Fri, 10 Jul 2009 12:40:26 +0300
Message-Id: <1247218826.771.15.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Fri, 2009-07-10 at 11:29 +0200, Nick Piggin wrote:
> What I would like to see is we eventualy make the hard decision
> and cull 2 of them. If SLQB is not clearly better (or, if it is
> clearly worse) than the other allocators and it can't be improved,
> then it has failed my goals for it and I would prefer to remove it
> from the tree.

I'm not sure it's such a hard decision. SLAB is on it's way out because
SLUB and SLQB code are much cleaner and the debugging support is better.
As for SLUB vs. SLQB, I'm hoping to trick you, Mel, and others into
doing an "epic slab allocator performance battle" and post the numbers
once we have have everything merged to mainline. My gut feeling is that
SLQB is in the lead because SLUB hasn't addressed the Intel regression.

			Pekka

