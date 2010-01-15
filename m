Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab0AOUCz (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 15:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758137Ab0AOUCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 15:02:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58767 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123Ab0AOUCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 15:02:53 -0500
Date: Fri, 15 Jan 2010 21:02:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: Bart?omiej Zimo? <uzi18@o2.pl>, linux-kernel@vger.kernel.org,
        awalls@radix.net, linux-pm@lists.linux-foundation.org,
        danborkmann@googlemail.com
Subject: Re: [linux-pm] [suspend/resume] Re: userspace notification from
	module
Message-ID: <20100115200241.GF1345@ucw.cz>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001052223.21964.rjw@sisk.pl> <16a1b165.2fdc37c6.4b43b943.c6733@o2.pl> <201001060003.23419.rjw@sisk.pl> <1ab86ec9.7bc73105.4b43cd45.c2747@o2.pl> <20100106143534.A7EEA33C5F5@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106143534.A7EEA33C5F5@tippex.mynet.homeunix.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-01-06 15:35:34, Anders Eriksson wrote:
> 
> uzi18@o2.pl said:
> >  Ummm sorry, it's IM App, to be realible for such app it's needed to close
> > conn before suspend, because after resume tcp connections will wait
> > (especialy on linux) quiet a lot of time to broke and reconnect.
> 
> I don't know the details here, but shouldn't the kernel fix this internally?
> 
> If sufficient time have elapsed so the kernel _should_ have sent keep alives 
> etc on an othervise idle connection, they shold be sent immediately on resume. 
> If the other end has disappeared by then, the resulting port unreachable 
> should trigger a local closure of the tcp state which the app will notice 
> (EBADF, or similar). Or?

Patches welcome.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
