Return-Path: <linux-kernel-owner+w=401wt.eu-S932633AbXBNV0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbXBNV0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932635AbXBNV0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:26:03 -0500
Received: from gate.crashing.org ([63.228.1.57]:47613 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932633AbXBNV0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:26:00 -0500
Subject: Re: undefined symbol 'PS3_PS3AV'
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Thomas Meyer <thomas@m3y3r.de>
In-Reply-To: <20070214101719.GA25319@linux-sh.org>
References: <45D2A835.7020606@m3y3r.de>
	 <Pine.LNX.4.62.0702140955130.17463@pademelon.sonytel.be>
	 <20070214090701.GA11088@linux-sh.org>
	 <Pine.LNX.4.62.0702141100470.2949@pademelon.sonytel.be>
	 <20070214101719.GA25319@linux-sh.org>
Content-Type: text/plain
Date: Thu, 15 Feb 2007 08:25:08 +1100
Message-Id: <1171488308.20192.171.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-14 at 19:17 +0900, Paul Mundt wrote:
> On Wed, Feb 14, 2007 at 11:02:06AM +0100, Geert Uytterhoeven wrote:
> > On Wed, 14 Feb 2007, Paul Mundt wrote:
> > > This would seem like a reasonable candidate for a 'depends on' instead of
> > > a select..
> > 
> > That's what we originally had. But for the user it's simler if he can just
> > enable ps3fb and/or ps3snd (sound driver not yet finished), which both select
> > PS3_PS3AV.
> 
> Why not just have PS3_PS3AV def_bool y if ps3fb || ps3snd? Or if that
> doesn't work, just place the PS3FB option in arch/powerpc/platforms/ps3/Kconfig.
> 
> Of course if select obeyed the depends on, this wouldn't be a problem
> either..

I'd rather fix Kconfig to do the later...

Ben.


