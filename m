Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbZKMCEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbZKMCEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 21:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbZKMCEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 21:04:15 -0500
Received: from lo.gmane.org ([80.91.229.12]:37667 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbZKMCEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 21:04:14 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@collabora.co.uk>
Subject: Re: i686 quirk for AMD Geode
Date: Thu, 12 Nov 2009 21:03:51 -0500
Message-ID: <20091112210351.459994c2@mycelium.queued.net>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
	<20091003072127.GC21407@elte.hu>
	<40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com>
	<4AF4526B.4060101@zytor.com>
	<40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com>
	<20091109201608.GD15159@caffeine.csclub.uwaterloo.ca>
	<4AF886D4.1080108@zytor.com>
	<20091109212333.GE15159@caffeine.csclub.uwaterloo.ca>
	<20091112121805.GF1394@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: wireless.queued.net
In-Reply-To: <20091112121805.GF1394@ucw.cz>
X-Newsreader: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 13:18:05 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > > > The Geode NX (which no one has mentioned yet) is an Athlon
> > > > derived chip.
> > > 
> > > *As far as I know* K6 didn't have NOPL, whereas K7 does.
> > 
> > Which would be mroe indication that the Geode LX may in fact be a K6
> > based CPU design.  The Geode NX is very clearly an Athlon (K7) and
> > AMD has never even tried to hide that.  They have never said what
> > the LX is based on, other than it isn't based on the GX
> > (fortunately, that thing was a buggy piece of crap).
> 
> Interesting...geode gx being buggy? I know pentium was famous for the
> fdiv bug, but never heard of geode gx problems...

http://www.amd.com/files/connectivitysolutions/geode/geode_gx/31533E_gx_2.1_specupdate.pdf

1.4 is my favorite.  The branch prediction logic can send the
instruction pointer off to la-la land.

While at olpc, we had a sad discussion about what the *real* impact of
the workaround was...




