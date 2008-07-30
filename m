Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbYG3SqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbYG3SqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYG3SqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:46:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:39128 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbYG3SqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:46:07 -0400
Date: Wed, 30 Jul 2008 20:46:03 +0200
From: Karsten Keil <kkeil@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Woodhouse <dwmw2@infradead.org>, isdn4linux@listserv.isdn4linux.de,
       Marcel Holtmann <marcel@holtmann.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mISDN cleanup user interface
Message-ID: <20080730184603.GA14922@pingi.kke.suse.de>
References: <20080729195637.GB25929@pingi.kke.suse.de> <1217362946.27925.137.camel@pmac.infradead.org> <1217365330.417.8.camel@californication> <1217409211.27925.177.camel@pmac.infradead.org> <20080730163314.GB9491@pingi.kke.suse.de> <1217437021.3454.8.camel@pmac.infradead.org> <20080730175138.GA12800@pingi.kke.suse.de> <20080730183721.GA29639@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730183721.GA29639@uranus.ravnborg.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 08:37:21PM +0200, Sam Ravnborg wrote:
> On Wed, Jul 30, 2008 at 07:51:38PM +0200, Karsten Keil wrote:
> > On Wed, Jul 30, 2008 at 05:57:01PM +0100, David Woodhouse wrote:
> > > On Wed, 2008-07-30 at 18:33 +0200, Karsten Keil wrote:
> > > > What about this implementation ?
> > > 
> > > Looks a lot saner... although it does seem to confirm my earlier
> > > suspicion that you're not even _using_ the fact that it's a bitmap at
> > > all. You set the bits for the present channels at init time, which are
> > > always contiguous, and you never seem to change them them later -- why
> > > couldn't you do this with a simple 'number of channels' integer?
> > 
> > No it is not contineous on different PRI line setups (E1,T1 ...)
> > e.g a E1 has the D-channel on channel 15 position, so this bit is not set
> > then.
> timeslot 16 in my book actually - but maybe that your timeslot to
> channel mapping.
> 

You are correct of course.

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
