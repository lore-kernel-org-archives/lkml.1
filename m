Return-Path: <linux-kernel-owner+w=401wt.eu-S1758826AbYAIBS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbYAIBS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYAIBSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:18:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbYAIBSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:18:47 -0500
Date: Wed, 9 Jan 2008 02:18:46 +0100
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-ID: <20080109011846.GE25945@bingen.suse.de>
References: <20080108232803.GA19906@elte.hu> <20080108234449.GA24274@elte.hu> <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu> <20080109004329.GA6603@elte.hu> <47841EB1.1020304@goop.org> <20080109011609.GB29807@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109011609.GB29807@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 02:16:09AM +0100, Ingo Molnar wrote:
> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > This isn't correct, because it will set _PAGE_GLOBAL on 32-bit 
> > unconditionally.  It needs to be something like:
> 
> hm, why is that a problem? 

Not so ancient 32bit CPUs didn't support global. 

> Ah, the VDSO page must not be global-mapped, 

That too.

-Andi
