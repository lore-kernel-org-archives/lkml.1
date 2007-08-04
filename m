Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbXHDXkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbXHDXkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 19:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757300AbXHDXkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 19:40:01 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:35478 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226AbXHDXj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 19:39:59 -0400
Date: Sun, 5 Aug 2007 08:39:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Rob Landley <rob@landley.net>
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roland Dreier <rdreier@cisco.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Group architecture Documentation under Documentation/arch.
Message-ID: <20070804233911.GA29364@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Rob Landley <rob@landley.net>, Jesper Juhl <jesper.juhl@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Roland Dreier <rdreier@cisco.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <200705222225.39949.rob@landley.net> <200708041422.04493.rob@landley.net> <9a8748490708041224s43bf9c1wcfecf1f7bb4e3055@mail.gmail.com> <200708041433.30450.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708041433.30450.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 03:33:29PM -0400, Rob Landley wrote:
> On Saturday 04 August 2007 2:24:46 pm Jesper Juhl wrote:
> > On 04/08/07, Rob Landley <rob@landley.net> wrote:
> > > On Saturday 04 August 2007 2:07:31 pm Jesper Juhl wrote:
> > > > On 04/08/07, Rob Landley <rob@landley.net> wrote:
> > > > > Signed-off-by: Rob Landley <rob@landley.net>
> > > > > Amiga part Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > > > >
> > > > > Move architecture-specific Documentation into a common subdirectory.
> > > >
> > > > ...
> > > >
> > > > I have only one complaint; I don't see an update to
> > > > Documentation/00-INDEX
> > >
> > > I now have at least three.  (I missed blackfin, which wasn't there last
> > > time I did this.)
> >
> > I'm not talking about Documentation/<arch>/00-INDEX, but the 00-INDEX
> > file in the top-level Documentation directory.
> >
> > Or am I misunderstanding you?
> 
> I now have at least three complaints about the patch I just submitted: Your 
> complaint is valid, the empty directories all the files were moved out of 
> don't seem to be deleted when I use git to apply this patch, and I didn't 
> move the blackfin directory into arch because it wasn't there when I 
> initially did this patch.

There's also the single file entries that are tightly coupled to an
architecture to consider as well. Both sgi-visws.txt and voyager.txt
should be consolidated with the i386 stuff, for example.
