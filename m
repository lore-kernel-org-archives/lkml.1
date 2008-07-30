Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbYG3SiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbYG3SiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYG3Sh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:37:56 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:53673 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbYG3Sh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:37:56 -0400
Date: Wed, 30 Jul 2008 20:37:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Karsten Keil <kkeil@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>, isdn4linux@listserv.isdn4linux.de,
       Marcel Holtmann <marcel@holtmann.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mISDN cleanup user interface
Message-ID: <20080730183721.GA29639@uranus.ravnborg.org>
References: <20080729195637.GB25929@pingi.kke.suse.de> <1217362946.27925.137.camel@pmac.infradead.org> <1217365330.417.8.camel@californication> <1217409211.27925.177.camel@pmac.infradead.org> <20080730163314.GB9491@pingi.kke.suse.de> <1217437021.3454.8.camel@pmac.infradead.org> <20080730175138.GA12800@pingi.kke.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730175138.GA12800@pingi.kke.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 07:51:38PM +0200, Karsten Keil wrote:
> On Wed, Jul 30, 2008 at 05:57:01PM +0100, David Woodhouse wrote:
> > On Wed, 2008-07-30 at 18:33 +0200, Karsten Keil wrote:
> > > What about this implementation ?
> > 
> > Looks a lot saner... although it does seem to confirm my earlier
> > suspicion that you're not even _using_ the fact that it's a bitmap at
> > all. You set the bits for the present channels at init time, which are
> > always contiguous, and you never seem to change them them later -- why
> > couldn't you do this with a simple 'number of channels' integer?
> 
> No it is not contineous on different PRI line setups (E1,T1 ...)
> e.g a E1 has the D-channel on channel 15 position, so this bit is not set
> then.
timeslot 16 in my book actually - but maybe that your timeslot to
channel mapping.

Not that it has anything to do with the topic discussed!

	Sam
