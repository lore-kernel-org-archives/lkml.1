Return-Path: <linux-kernel-owner+w=401wt.eu-S935002AbXHLNrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935002AbXHLNrw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 09:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759068AbXHLNrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 09:47:43 -0400
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:54495 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbXHLNrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 09:47:43 -0400
Date: Sun, 12 Aug 2007 15:46:23 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Andi Kleen <andi@firstfloor.org>
Cc: Petr Vandrovec <petr@vandrovec.name>, discuss@x86-64.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Please remove ab144f5ec64c42218a555ec1dbde6b60cf2982d6 was Re:
 [discuss] [PATCH] Fix triplefault on x86-64 bootup
Message-ID: <20070812154623.6000ae68@localhost>
In-Reply-To: <p731we8kgbd.fsf@bingen.suse.de>
References: <20070812081252.GA23309@vana.vc.cvut.cz>
	<200708121209.40995.ak@suse.de>
	<46BEE427.3020904@vandrovec.name>
	<p731we8kgbd.fsf@bingen.suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 Aug 2007 15:55:50 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > > Ok Linus already applied your patch. Even though it's a really bad
> > > fragile hack, not better than the old bug.
> > > Petr are you double sure you really tested with
> > > ab144f5ec64c42218a555ec1dbde6b60cf2982d6
> > > already applied? I bet not -- it is the symptom exactly fixed by this patch  
> > 
> > I'm quite sure that this patch is in my tree, as I have that "u8
> > *instr = a->instr;" in apply_alternatives, and it seems that this one
> > was added by checkin you mention...  My tree was synced up to:  
> 
> Can you double check? I have a hard time believing it.

I've seen the reboot too, with "rc2-g3864e8cc" that is newer than
ab144f5ec64c4:

	$ git-log ab144f5ec64c4..| grep 3864e8cc
	commit 3864e8ccbba1dcdea87398ab80fdc8ae0fab7c45

-- 
	Paolo Ornati
	Linux 2.6.23-rc2-gac078602 on x86_64
