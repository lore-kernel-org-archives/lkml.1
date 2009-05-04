Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbZEDNbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbZEDNbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 09:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbZEDNbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 09:31:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:60381 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbZEDNbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 09:31:33 -0400
Date: Mon, 4 May 2009 06:32:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tobias Doerffel <tobias.doerffel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Willy Tarreau <w@1wt.eu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Specific support for Intel Atom architecture
Message-ID: <20090504063258.00d035b2@infradead.org>
In-Reply-To: <20090504131457.GA25844@elte.hu>
References: <200904301408.09370.tobias.doerffel@gmail.com>
	<20090503053821.GI570@1wt.eu>
	<49FD3E56.3010803@zytor.com>
	<200905031308.51316.tobias.doerffel@gmail.com>
	<20090504131457.GA25844@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009 15:14:57 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Tobias Doerffel <tobias.doerffel@gmail.com> wrote:
> 
> > Am Sonntag, 3. Mai 2009 08:48:54 schrieb H. Peter Anvin:
> > > Willy Tarreau wrote:
> > > >> $(call cc-option,-march=atom,-march=i686)
> > > >
> > > > if it's an in-order architecture, wouldn't it be better to tune
> > > > for i386 or i486 instead ?
> > >
> > > Possibly.  It would be worth measuring.
> >
> > How would one do that (never benchmarked kernel stuff before)?
> 
> A standard method is to run lmbench and compare the results - 
> lmbench has a built-in 'report comparison between two runs' feature.

well... you're normally REALLY hard pressed to measure compiler
differences this way..... 

normally compiler options get benchmarked using speccpu and the like....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
