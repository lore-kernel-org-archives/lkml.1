Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXHDTdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXHDTdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765217AbXHDTdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:33:42 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:42132
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611AbXHDTdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:33:41 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH 1/2] Group architecture Documentation under Documentation/arch.
Date: Sat, 4 Aug 2007 15:33:29 -0400
User-Agent: KMail/1.9.6
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Roland Dreier" <rdreier@cisco.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-doc@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Paul Mundt" <lethal@linux-sh.org>
References: <200705222225.39949.rob@landley.net> <200708041422.04493.rob@landley.net> <9a8748490708041224s43bf9c1wcfecf1f7bb4e3055@mail.gmail.com>
In-Reply-To: <9a8748490708041224s43bf9c1wcfecf1f7bb4e3055@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708041433.30450.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 August 2007 2:24:46 pm Jesper Juhl wrote:
> On 04/08/07, Rob Landley <rob@landley.net> wrote:
> > On Saturday 04 August 2007 2:07:31 pm Jesper Juhl wrote:
> > > On 04/08/07, Rob Landley <rob@landley.net> wrote:
> > > > Signed-off-by: Rob Landley <rob@landley.net>
> > > > Amiga part Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > > >
> > > > Move architecture-specific Documentation into a common subdirectory.
> > >
> > > ...
> > >
> > > I have only one complaint; I don't see an update to
> > > Documentation/00-INDEX
> >
> > I now have at least three.  (I missed blackfin, which wasn't there last
> > time I did this.)
>
> I'm not talking about Documentation/<arch>/00-INDEX, but the 00-INDEX
> file in the top-level Documentation directory.
>
> Or am I misunderstanding you?

I now have at least three complaints about the patch I just submitted: Your 
complaint is valid, the empty directories all the files were moved out of 
don't seem to be deleted when I use git to apply this patch, and I didn't 
move the blackfin directory into arch because it wasn't there when I 
initially did this patch.

I'll resubmit with 00-INDEX updates and blackfin moved, as soon as I figure 
out how to tell git to DELETE THE DARN EMPTY DIRECTORIES ALREADY...

(I am seriously suspecting "edit the patch in vi" is going to be part of the 
solution here.  I _like_ mercurial.  I know where to hit it and what with to 
make it behave.  Git, not so much...)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
