Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbXERLyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbXERLyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 07:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbXERLyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 07:54:14 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:48918 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbXERLyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 07:54:13 -0400
Subject: Re: [RFC] LZO1X de/compression support
From: Richard Purdie <richard@openedhand.com>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: Heikki Orsila <shdl@zakalwe.fi>, linux-kernel@vger.kernel.org,
       "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
In-Reply-To: <4cefeab80705180427u54110396mfb3acd96c6c446bd@mail.gmail.com>
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
	 <20070518101449.GH10873@zakalwe.fi>
	 <4cefeab80705180427u54110396mfb3acd96c6c446bd@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 May 2007 12:53:48 +0100
Message-Id: <1179489229.5876.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 16:57 +0530, Nitin Gupta wrote:
> On 5/18/07, Heikki Orsila <shdl@zakalwe.fi> wrote:
> > Good work..
> >
> > On Fri, May 18, 2007 at 03:28:31PM +0530, Nitin Gupta wrote:
> > > Facts for LZO (at least for original code. Should hold true for this
> > > port also - hence the RFC!):
> > > - The compressor can never overrun buffer.
> > > - The "non-safe" version of decompressor can never overrun buffer if
> > > compressed data is unmodified. I am not sure about this if compressed
> > > data is malicious (to be confirmed from the author).
> > > - The "safe" version can never crash (buffer overrun etc.) - confirmed
> > > from the author.
> >
> > What's the proof?
> 
> I confirmned these from the author - I just ported this code. I think
> he can answer you better - CC'ed him  :-)

The thing is this is more your code now, not his and you should be able
to answer this question...

Regards,

Richard

