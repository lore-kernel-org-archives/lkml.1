Return-Path: <linux-kernel-owner+w=401wt.eu-S1760827AbZJMSES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827AbZJMSES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760814AbZJMSER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:04:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760813AbZJMSER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:04:17 -0400
Date: Tue, 13 Oct 2009 11:01:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frans Pop <elendil@planet.nl>
cc: Ingo Molnar <mingo@elte.hu>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
In-Reply-To: <200910131952.01209.elendil@planet.nl>
Message-ID: <alpine.LFD.2.01.0910131100180.26777@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910130004.46388.elendil@planet.nl> <20091013070505.GC31483@elte.hu> <200910131952.01209.elendil@planet.nl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Oct 2009, Frans Pop wrote:
> On Tuesday 13 October 2009, Ingo Molnar wrote:
> >
> > Is this a bad thing?
> 
> IMHO yes. This change essentially creates a backwards incompatibility with 
> existing naming schemes. Requiring to patch the change out to preserve an 
> existing naming scheme just seems a tad unfriendly.

Let's keep the old behavior by making the AUTO option an three-way choice 
("none", "short", "auto"), and making sure that it actually takes work to 
choose "none" (and that "make oldconfig" doesn't choose it unless you 
explicitly made the choice before - so people who just re-use old .config 
files wouldn't get "none" by mistake).

		Linus
