Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbZGJJv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbZGJJv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZGJJvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:51:49 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35607 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbZGJJvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:51:48 -0400
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already
 using mudflap
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, fche@redhat.com, cl@linux-foundation.org
In-Reply-To: <alpine.DEB.2.00.0907100243010.14601@chino.kir.corp.google.com>
References: <1247156020.27671.40.camel@debian-nb>
	 <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com>
	 <20090710084745.GA26752@elte.hu> <1247215920.32044.3.camel@penberg-laptop>
	 <20090710090351.GD14666@wotan.suse.de>
	 <1247217263.771.8.camel@penberg-laptop>
	 <20090710092921.GF14666@wotan.suse.de>
	 <1247218826.771.15.camel@penberg-laptop>
	 <alpine.DEB.2.00.0907100243010.14601@chino.kir.corp.google.com>
Date: Fri, 10 Jul 2009 12:51:46 +0300
Message-Id: <1247219506.771.22.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Fri, 10 Jul 2009, Pekka Enberg wrote:
> > I'm not sure it's such a hard decision. SLAB is on it's way out because
> > SLUB and SLQB code are much cleaner and the debugging support is better.

On Fri, 2009-07-10 at 02:47 -0700, David Rientjes wrote:
> I don't think that is good enough reason.  CONFIG_SLAB is by far the 
> optimal choice for netperf TCP_RR on >= 16 cpus and pushing it out of the 
> tree, even though it is no longer the default option, isn't an option for 
> those of us who live by performance even if it comes at the cost of a 
> dirtier implementation (enhanced debugging support doesn't even register 
> on my radar since it's useless in a production environment).

Hey, I said SLAB is on its way out (yes, it really is). But I didn't say
we're going to blindly remove it if performs better than the
alternatives. I don't see any reason why SQLB can't reach the same
performance as SLAB after on fundamental level, though. Can you?

			Pekka

