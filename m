Return-Path: <linux-kernel-owner+w=401wt.eu-S1761403AbYHFRZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403AbYHFRZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbYHFRY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:24:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:36733 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbYHFRY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:24:56 -0400
Date: Wed, 6 Aug 2008 10:24:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Stephane Marchesin" <marchesin@icps.u-strasbg.fr>
Cc: "Keith Packard" <keithp@keithp.com>, "John Stoffel" <john@stoffel.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Eric Anholt" <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Message-ID: <20080806102437.2d5e5d11@infradead.org>
In-Reply-To: <6a89f9d50808060920t168d533g5d440b444e7c09fc@mail.gmail.com>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	<200808042043.46710.nickpiggin@yahoo.com.au>
	<1217850352.24714.66.camel@koto.keithp.com>
	<Pine.LNX.4.64.0808041720500.25617@blonde.site>
	<1217870748.24714.79.camel@koto.keithp.com>
	<Pine.LNX.4.64.0808041855050.5717@blonde.site>
	<1217877645.24714.87.camel@koto.keithp.com>
	<Pine.LNX.4.64.0808042055240.17041@blonde.site>
	<18583.47633.987143.236236@stoffel.org>
	<1217910505.24714.152.camel@koto.keithp.com>
	<6a89f9d50808060920t168d533g5d440b444e7c09fc@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 18:20:40 +0200
"Stephane Marchesin" <marchesin@icps.u-strasbg.fr> wrote:

> On 8/5/08, Keith Packard <keithp@keithp.com> wrote:
> > On Mon, 2008-08-04 at 22:25 -0400, John Stoffel wrote:
> >
> >  > What about the onboard memory of graphics cards?  Isn't that
> >  > where Textures and such are stored as well?  So once something
> >  > is loaded to the card, shouldn't you be able to free it in
> >  > system memory?  Or swap it out ahead of time?
> >
> >
> > Right now, I'm working only on Intel integrated graphics, which
> > doesn't have any on-board memory. My thinking is that we'd best
> > solve the easiest case first before attempting the harder discrete
> > graphics driver. Plus, Intel pays me do do integrated graphics, so
> > I have an incentive.
> >
> 
> Right, but it sounds adventurous to merge this work upstream before it
> is generic enough to work on discrete cards. Right now it only works
> on intel integrated cards ; integrated cards are one business,
> discrete are a completely different world and the issues afoot
> completely different.
> 
> Should this go upstream, the kernel guys have to keep in mind and
> accept the possibility that another memory manager might be needed at
> some point.

the ATI driver guys already have the interface working.

In addition.. since when is "oh you must also make it work for THAT" a
requirement? Traditionally, it's up to the second person to make
generic code work for them (within reason of course, but I'll argue
that the bar of reasonableness has been met here)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
