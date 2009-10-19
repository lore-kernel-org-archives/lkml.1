Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbZJUH4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbZJUH4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 03:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZJUH4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 03:56:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35682 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZJUH4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 03:56:32 -0400
Date: Mon, 19 Oct 2009 23:38:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
       rjw@sisk.pl, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.30 leaking keys on console switch
Message-ID: <20091019213836.GD1482@ucw.cz>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907081317000.27327@wotan.suse.de> <20091014045851.GA32413@core.coreip.homeip.net> <20091014071950.GF23248@one.firstfloor.org> <20091014073927.GB5318@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014073927.GB5318@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-10-14 00:39:28, Dmitry Torokhov wrote:
> On Wed, Oct 14, 2009 at 09:19:50AM +0200, Andi Kleen wrote:
> > > Btw, what kind of keyboard is this? I was playing today but I could not
> > > get my USB keyboards to report release of more than 1 key per report....
> > 
> > The log was with a PS/2<->USB adapter, with a PS/2 keyboard connected
> > to a USB port through it.
> > 
> 
> Hmm, I don't think I have one of those... It is curious beast - we have
> software autorepeat for HID but PS/2 keyboards do autorepeat
> themselves... What will combination do?

I always wondered how that's supposed to work... on loaded system. As
linux is not realtime system, it can't, afaict.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
