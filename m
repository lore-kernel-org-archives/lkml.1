Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbXGALrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbXGALrN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 07:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbXGALrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 07:47:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:35771 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755553AbXGALrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 07:47:01 -0400
X-Authenticated: #4399952
X-Provags-ID: V01U2FsdGVkX1+ckjsV7mOc8pUGfetHnNQVRtOdfM3VUGFSspq0w2
	LJp5z37Srn0TcP
From: Florian Schmidt <mista.tapas@gmx.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Date: Sun, 1 Jul 2007 13:46:52 +0200
User-Agent: KMail/1.9.6
Cc: alan@lxorguk.ukuu.org.uk, bunk@stusta.de, nix@esperi.org.uk,
       galibert@pobox.com, tiwai@suse.de, kloczek@rudy.mif.pg.gda.pl,
       linux-kernel@vger.kernel.org
References: <20070624200837.16e11305@the-village.bc.nu> <E1I4IoZ-0003Hm-00@dorka.pomaz.szeredi.hu> <E1I4J76-0003MW-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I4J76-0003MW-00@dorka.pomaz.szeredi.hu>
X-Face: %EpW[IH18fBP*R?oz~]%Klbl.q!_(Xs_q"t?K~RVx[c7~3|C3kDdA(8y_KOB\{(Rn(=?utf-8?q?MZhm=0A=09=7B/l=2E?=>O48>i9k<+(,c^Y%mGm)M\+RxuxL4r<7-W63sB$+w\}hkT"Q2?v&N:y\Z
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707011346.52872.mista.tapas@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 June 2007, Miklos Szeredi wrote:
> > > > Not as if it would be hard to add ioctl support to fuse.  What fuse
> > > > can't handle is the data argument of ioctl(), so the most it could do
> > > > is give the filesystem a pid (tid) and a virtual address.  The
> > > > userspace fs could then get/put the data through /proc/<pid>/mem.
> > >
> > > Hork...
> > >
> > > Identify the generic ioctls that are relevant to a FUSE file system and
> > > have real meaning *and* are useful.
> >
> > I don't think there are any such.
> >
> > The point in this thread was I think about emulating an OSS sound
> > device through a fuse fs.  In that case fuse would need _generic_
> > ioctl support, which simply can't be done without weird userspace
> > hacks.
>
> Well, had a look at what FUSD does.  It assumes that the ioctl
> argument is stuctured according to the command.  If all OSS ioctls are
> like that, then fine, fuse can support it properly.
>
> The drawback of this is that ioctls which aren't structured properly
> could cause weird failures due to wrong data being accessed by the
> poor unknowing kernel.
>
> Miklos

Included with the docs there's a list of the OSS ioctls. I don't understand 
enough of the problem to judge whether they are suitable to be handled by 
FUSE:

http://manuals.opensound.com/developer/ioctl.html [version 4]
http://www.4front-tech.com/pguide/oss.pdf [version 3]

I don't know which API version is supposed to be supported though.

Regards,
Flo

-- 
Palimm Palimm!
http://tapas.affenbande.org
