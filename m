Return-Path: <linux-kernel-owner+w=401wt.eu-S1761720AbYF0SOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761720AbYF0SOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbYF0SNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:13:54 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:44928 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbYF0SNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:13:53 -0400
Date: Fri, 27 Jun 2008 20:13:04 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Adrian Bunk <bunk@kernel.org>,
       Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       "Nelson, Shannon" <shannon.nelson@intel.com>
Subject: Re: [PATCH v4 4/6] dmaengine: Make DMA Engine menu visible for
 AVR32 users
Message-ID: <20080627201304.188458be@siona.local>
In-Reply-To: <200806270937.21850.david-b@pacbell.net>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	<20080626164601.712bf048@hskinnemo-gx745.norway.atmel.com>
	<1214528379.32709.51.camel@dwillia2-linux.ch.intel.com>
	<200806270937.21850.david-b@pacbell.net>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2008 18:13:06.0283 (UTC) FILETIME=[7276D3B0:01C8D881]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 09:37:21 -0700
David Brownell <david-b@pacbell.net> wrote:

> On Thursday 26 June 2008, Dan Williams wrote:
> > I agree with removing the arch dependency, and I do not think we
> > necessarily need to add HAVE_DMA_ENGINE.
> 
> I think a HAVE_DMA_ENGINE would be better than what you're doing
> below:  moving the arch dependency into the network code, and
> adding this !HIGHMEM64G thing (which is really just a more subtle
> arch dependency).

The !HIGHMEM64G dependency wasn't added; it was there before. I happen
to believe the code that breaks HIGHMEM64G is rather ugly, but that's no
reason to NAK this particular patch. Besides, I'm not really that
interested in the XOR parts of the framework.

> Note that HAS_DMA is very different from having DMA engine support...
> one is a specific interface, the other is the generic mechanism with
> any of its numerous (and often peripheral-specific) interfaces.

They may be different, but you can't have DMA engine support on
platforms that don't provide the DMA mapping API. At least not at the
moment.

The patch looks good to me.

Haavard
