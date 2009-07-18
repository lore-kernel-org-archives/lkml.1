Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZGRSdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZGRSdI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 14:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZGRSdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 14:33:07 -0400
Received: from relais.videotron.ca ([24.201.245.36]:9396 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbZGRSdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 14:33:06 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_AGfTd+n7egBtrtuqNBS0PQ)"
Date: Sat, 18 Jul 2009 14:32:59 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>,
       stable@const.famille.thibault.fr
Subject: Re: vc: create vcs(a) devices for consoles
In-reply-to: <20090718161926.GN28509@const.famille.thibault.fr>
Message-id: <alpine.LFD.2.00.0907181431400.3138@xanadu.home>
References: <1247931257.29760.1.camel@yio.site>
 <20090718160101.GA13346@kroah.com>
 <ac3eb2510907180912u7b30d8actcfab15776fe2d99d@mail.gmail.com>
 <20090718161926.GN28509@const.famille.thibault.fr>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_AGfTd+n7egBtrtuqNBS0PQ)
Content-type: TEXT/PLAIN; charset=iso-8859-1
Content-transfer-encoding: 8BIT

On Sat, 18 Jul 2009, Samuel Thibault wrote:

> Kay Sievers, le Sat 18 Jul 2009 18:12:20 +0200, a écrit :
> > On Sat, Jul 18, 2009 at 18:01, Greg KH<greg@kroah.com> wrote:
> > > On Sat, Jul 18, 2009 at 05:34:17PM +0200, Kay Sievers wrote:
> > >> From: Kay Sievers <kay.sievers@vrfy.org>
> > >> Subject: vc: create vcs(a) devices for consoles
> > >>
> > >> The buffer for the consoles are unconditionally allocated at
> > >> con_init() time, which miss the creation of the vcs(a) devices.
> > >>
> > >> Since 2.6.30, these devices are no longer created at open()
> > >> and removed on close(), but controlled by the lifetime of the
> > >> buffers.
> > >
> > > Is this a bug in .31-rc right now?  Should this make it into the final
> > > .31 release?
> > 
> > Yes, and in .30.
> 
> Please also push it to stable@kernel.org The bug makes the console
> unusable e.g. for blind users using braille devices.

... as well as blind developers as myself.  Thanks for fixing this.


Nicolas

--Boundary_(ID_AGfTd+n7egBtrtuqNBS0PQ)--
