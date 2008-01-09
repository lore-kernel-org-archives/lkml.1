Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYAIBiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYAIBiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbYAIBh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:37:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:52659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737AbYAIBh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:37:56 -0500
Date: Wed, 9 Jan 2008 02:37:55 +0100
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-ID: <20080109013754.GF25945@bingen.suse.de>
References: <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu> <20080109004329.GA6603@elte.hu> <47841EB1.1020304@goop.org> <20080109011609.GB29807@elte.hu> <20080109011846.GE25945@bingen.suse.de> <20080109012257.GB1133@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109012257.GB1133@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 02:22:57AM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > On Wed, Jan 09, 2008 at 02:16:09AM +0100, Ingo Molnar wrote:
> > > 
> > > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > > 
> > > > This isn't correct, because it will set _PAGE_GLOBAL on 32-bit 
> > > > unconditionally.  It needs to be something like:
> > > 
> > > hm, why is that a problem?
> > 
> > Not so ancient 32bit CPUs didn't support global.
> 
> 'not so ancient' like: pre-PPro ones? But we mark the ptes PAGE_GLOBAL 

AMD K6 at least AFAIK -- that's not ancient. I still got one of those.

-Andi
