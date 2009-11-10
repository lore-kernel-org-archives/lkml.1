Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbZKJGy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbZKJGy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 01:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbZKJGy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 01:54:56 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:58841 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZKJGy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 01:54:56 -0500
Date: Tue, 10 Nov 2009 07:54:57 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Dan Williams <dcbw@redhat.com>
Cc: netdev@vger.kernel.org, libertas-dev@lists.infradead.org,
       Michael Hirsch <m.hirsch@raumfeld.com>, linux-kernel@vger.kernel.org
Subject: Re: Libertas related kernel crash
Message-ID: <20091110065457.GL14091@buzzloop.caiaq.de>
References: <20091105120549.GQ14091@buzzloop.caiaq.de>
 <20091109155354.GC14091@buzzloop.caiaq.de>
 <1257835893.15493.37.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257835893.15493.37.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 10:51:33PM -0800, Dan Williams wrote:
> On Mon, 2009-11-09 at 16:53 +0100, Daniel Mack wrote:
> > On Thu, Nov 05, 2009 at 01:05:49PM +0100, Daniel Mack wrote:
> > > On an ARM (PXA300) embdedded platform with a libertas chip connected via
> > > SDIO, we happen to see the kernel Ooops below once in a while.
> > > 
> > > Any pointer on where to dig?
> > 
> > Some more input on this. Oopses similar to the one below are likely
> > triggered when switching from Ad-hoc to managed mode multiple times in a
> > row, and something seems corrupt the memory badly. I've searched for the
> > obvious (double frees, out-of-bound writes etc), but I couldn't find
> > anything yet. It is, however, related to the wireless core and/or the
> > libertas driver.
> 
> Probably just libertas.  Any chance you can enable debugging options
> (either in libertas, or in the kernel allocator) to help narrow down the
> issue?

Sure. I already enabled DEBUG_VM, but that didn't spit out anything
before it crashes. Which other debug flags would you recommend to set?

Daniel
