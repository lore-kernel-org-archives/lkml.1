Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbXJYITV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbXJYITV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757429AbXJYIS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:18:56 -0400
Received: from www.tglx.de ([62.245.132.106]:37482 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848AbXJYISy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:18:54 -0400
Date: Thu, 25 Oct 2007 10:18:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andres Salomon <dilinger@queued.net>
cc: Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4 resend] [x86] Add generic GPIO support to x86
In-Reply-To: <20071022151845.5874fba3@ephemeral>
Message-ID: <alpine.LFD.0.9999.0710251013170.3186@localhost.localdomain>
References: <200710181551.24912.florian.fainelli@telecomint.eu> <20071018173828.159b15dd@ephemeral> <200710191401.56916.florian.fainelli@telecomint.eu> <20071022151845.5874fba3@ephemeral>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1731074905-1193300326=:3186"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1731074905-1193300326=:3186
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 22 Oct 2007, Andres Salomon wrote:
> On Fri, 19 Oct 2007 14:01:56 +0200
> Florian Fainelli <florian.fainelli@telecomint.eu> wrote:
> 
> > Hi Andres,
> > 
> > Le jeudi 18 octobre 2007, Andres Salomon a écrit :
> > > While I certainly would like to see a generic GPIO API, this one
> > > isn't really useful for geode GPIOs.  It would be nice to have one
> > > that did work for us as well.  Unfortunately, I haven't had the
> > > chance to give much thought to this problem yet.
> > 
> > This one was discussed mostly on the ARM mailing-list and finally
> > made his way to the mainline kernel. Though it lacks some functions
> > to change for instance a entire GPIO line and not a single bit, it is
> > used on ARM and MIPS systems so I would conform with this one for now
> > because it is used by at least two or more architectures.
> 
> How does being used on MIPS and ARM make it suitable for x86?  If
> you're arguing that other x86 platforms conform to it, and it might be
> useful for them; sure, I'll buy that.  That doesn't seem to currently be
> the case, though.

It might be useful for everyone to check, whether the existing GPIO
functionality can be extended, reworked to match the needs of Geode as
well. Extending / reworking an existing interface is definitely
better than adding a new incompatible one.

       tglx
--8323328-1731074905-1193300326=:3186--
