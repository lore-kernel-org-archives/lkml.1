Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbYGUVmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbYGUVmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYGUVmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:42:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54872 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750836AbYGUVmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:42:15 -0400
Date: Mon, 21 Jul 2008 22:24:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ben Collins <bcollins@swissdisk.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VT: Restore VT fonts on switch
Message-ID: <20080721222428.20395240@lxorguk.ukuu.org.uk>
In-Reply-To: <20080721213735.GA11648@srcf.ucam.org>
References: <E1KL0tq-0001Wk-Ny@critter.phunnypharm.org>
	<20080721134327.3ffab96f@infradead.org>
	<1216673584.7585.189.camel@cunning>
	<20080721221204.1f3be45d@lxorguk.ukuu.org.uk>
	<20080721213735.GA11648@srcf.ucam.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 22:37:35 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Mon, Jul 21, 2008 at 10:12:04PM +0100, Alan Cox wrote:
> > > > do you have a list of which ones don't ?
> > > 
> > > I don't, but perhaps Matthew does.
> > 
> > Perhaps Matthew would care to file X bugs against those that get it wrong
> > then.
> 
> It's hardly limited to X. Fonts are set through the kernel - why 
> shouldn't it be the kernel's responsibility to ensure that they're 
> restored?

Why should it be the kernels problem to clean up after buggy X drivers ?

There are cases the kernel probably should handle font restore: the
obvious one being suspend/resume. X is not one of those cases and wasting
memory on fonts on embedded boxes that will never be seen anyway seems
silly.

For suspend/resume it might be far better to do it in user space,
although I'm not sure what the interface would look like.

Alan
