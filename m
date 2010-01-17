Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374Ab0AQDdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0AQDdn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 22:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476Ab0AQDdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 22:33:42 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41117 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932072Ab0AQDdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 22:33:41 -0500
X-Sasl-enc: hRZDbCOKr5hWqVZhuMIMTZ1ZLT9g4Ai/l7lNoHQ2EFQ1 1263699213
Date: Sun, 17 Jan 2010 01:33:29 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - reset inode permissions before
 unlinking
Message-ID: <20100117033329.GC6128@khazad-dum.debian.net>
References: <1263388596.26006.1.camel@yio.site>
 <20100114205304.GC3814@khazad-dum.debian.net>
 <ac3eb2511001141259t751c6063p8919692a8164e2b@mail.gmail.com>
 <20100114210743.GE3814@khazad-dum.debian.net>
 <ac3eb2511001141345w64d42ceckb4d73815298761c2@mail.gmail.com>
 <20100116022641.GF3814@khazad-dum.debian.net>
 <20100116033141.GB15306@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100116033141.GB15306@kroah.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jan 2010, Greg KH wrote:
> On Sat, Jan 16, 2010 at 12:26:41AM -0200, Henrique de Moraes Holschuh wrote:
> > On Thu, 14 Jan 2010, Kay Sievers wrote:
> > > > That said, this does fix a possible security problem when a misconfigured
> > > > system is used, and the fix looks rather simple... ?Can it go to -stable
> > > > eventually, even if it is months in the future, after it gets some testing
> > > > in .34 ? ? Minor problems are still problems...
> > > 
> > > Sure, we could do that. There is some stuff in the current .33 kernel,
> > > which could go into .32-stable too, if that's useful.
> > 
> > I think it probably would be useful.  I understand .32 is going to stay with
> > us for a long time, so it should get any fixes that have withstood the test
> > of time.
> > 
> > It is very annoying to have subtly different kernel behaviour (from
> > mainline) in a long-term stable series...
> 
> I've queued up this patch to go into the -stable trees.  Any other
> specific one you can think of should also go?

I understand Kay has some patches that are -stable material.  But note that
I'd be happy as long as they _eventually_ go to -stable (the patch in this
thread included), I have nothing against waiting the next mainline kernel
for it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
