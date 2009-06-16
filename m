Return-Path: <linux-kernel-owner+w=401wt.eu-S1761163AbZFPHqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761163AbZFPHqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 03:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbZFPHqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 03:46:04 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45602 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbZFPHqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 03:46:04 -0400
Subject: Re: linux-next: manual merge of the tip tree with the slab tree
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <20090616074446.GA10278@elte.hu>
References: <20090616154652.b8adcb9d.sfr@canb.auug.org.au>
	 <1245131318.3415.1.camel@penberg-laptop>  <20090616074446.GA10278@elte.hu>
Date: Tue, 16 Jun 2009 10:46:03 +0300
Message-Id: <1245138364.3415.39.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 09:44 +0200, Ingo Molnar wrote:
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > On Tue, 2009-06-16 at 15:46 +1000, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Today's linux-next merge of the tip tree got a conflict in mm/slub.c
> > > between commit 964cf35c88f93b4927dbc4e950dfa4d880c7f9d1 ("SLUB: Fix early
> > > boot GFP_DMA allocations") from the slab tree and commit
> > > 18fd427debcf37c06917b55295df682fd05fee76 ("slub: add hooks for
> > > kmemcheck") from the tip tree.
> > > 
> > > I fixed it up (see below) and can carry the fix as necessary.
> > 
> > Looks good! Thanks.
> 
> Btw., this SLAB commit is for this merge window, right?

Yes, it's a fix for SLUB that's going to be part of the next pull
request (probably out today or tomorrow).

			Pekka

