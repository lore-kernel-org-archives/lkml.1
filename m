Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbXIRGOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbXIRGOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 02:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbXIRGN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 02:13:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35682 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbXIRGN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 02:13:56 -0400
Date: Tue, 18 Sep 2007 11:46:40 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Borislav Petkov <bbpetkov@yahoo.de>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] unify DMA_..BIT_MASK definitions: v1
In-Reply-To: <20070918060854.GA14903@gollum.tnic>
Message-ID: <alpine.LFD.0.999.0709181145060.14771@enigma.security.iitk.ac.in>
References: <20070918042919.GA8998@gollum.tnic> <20070918055803.GB4640@rhun.haifa.ibm.com>
 <46EF69B1.8020801@goop.org> <20070918060854.GA14903@gollum.tnic>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,


On Tue, 18 Sep 2007, Borislav Petkov wrote:

> On Mon, Sep 17, 2007 at 11:01:21PM -0700, Jeremy Fitzhardinge wrote:
> > Muli Ben-Yehuda wrote:
> > >> +#define DMA_64BIT_MASK	DMA_BIT_MASK(64)
> > >>     
> > >
> > > This one does not do what you mean. You need an explicit mask or a
> > > ~0ULL here.
> > 
> > Yeah, I was just about to comment on it.  Its possible the compiler
> > might decide to shift by x%64 = 0.
> > 
> >     J
> ups, i knew that this might be a corner/boundary case. Thanks, updated patches
> follow...

Please fold all three patches into a single patch in the updated series,
otherwise git bisecters falling in between these patches will see the
"redefinition ... previous definition was here" warnings of gcc ...


Satyam
