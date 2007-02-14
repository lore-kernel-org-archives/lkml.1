Return-Path: <linux-kernel-owner+w=401wt.eu-S1751536AbXBNKT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbXBNKT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXBNKT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:19:29 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:46932 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbXBNKT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:19:28 -0500
Date: Wed, 14 Feb 2007 19:17:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Thomas Meyer <thomas@m3y3r.de>
Subject: Re: undefined symbol 'PS3_PS3AV'
Message-ID: <20070214101719.GA25319@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Linux/PPC Development <linuxppc-dev@ozlabs.org>,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Thomas Meyer <thomas@m3y3r.de>
References: <45D2A835.7020606@m3y3r.de> <Pine.LNX.4.62.0702140955130.17463@pademelon.sonytel.be> <20070214090701.GA11088@linux-sh.org> <Pine.LNX.4.62.0702141100470.2949@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0702141100470.2949@pademelon.sonytel.be>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 11:02:06AM +0100, Geert Uytterhoeven wrote:
> On Wed, 14 Feb 2007, Paul Mundt wrote:
> > This would seem like a reasonable candidate for a 'depends on' instead of
> > a select..
> 
> That's what we originally had. But for the user it's simler if he can just
> enable ps3fb and/or ps3snd (sound driver not yet finished), which both select
> PS3_PS3AV.

Why not just have PS3_PS3AV def_bool y if ps3fb || ps3snd? Or if that
doesn't work, just place the PS3FB option in arch/powerpc/platforms/ps3/Kconfig.

Of course if select obeyed the depends on, this wouldn't be a problem
either..
