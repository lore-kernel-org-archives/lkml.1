Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbYEQP3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbYEQP3A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbYEQP2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:28:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:47486 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747AbYEQP2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:28:52 -0400
Subject: Re: [PATCH] remove double indirection on tlb parameter to
	free_pgd_range() & Co
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Hugh Dickins <hugh@veritas.com>
Cc: Jan Beulich <jbeulich@novell.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrea Arcangeli <andrea@qumranet.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0805161517510.8758@blonde.site>
References: <482C6917.76E4.0078.0@novell.com>
	 <Pine.LNX.4.64.0805161517510.8758@blonde.site>
Content-Type: text/plain
Date: Sat, 17 May 2008 10:27:08 -0500
Message-Id: <1211038028.8297.131.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-16 at 15:39 +0100, Hugh Dickins wrote:
> 
> We'd several of us like to rework the mmu_gathering so as not to
> disable
> preemption: I got stuck and BenH took over, a patch much like yours
> below
> was a part of what I had - I too was glad to get rid of the **s.

Yup. I took over and somewhat froze.. I have some stuff partially done
(and that actually works) that changes the batching, moving it away from
per-cpu and improving the latency situation but I wasn't to happy with
some aspects of the resulting patches, and finally got pulled on various
other things, so this work took the dust.

I can try to dig my stuff out when I'm back from travelling, in a week
or so, if there is some interest. I was thinking about looking at it
again anyway.

Cheers,
Ben.


