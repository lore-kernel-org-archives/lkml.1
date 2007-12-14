Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbXLNOaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbXLNOaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 09:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbXLNOa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 09:30:27 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4160 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbXLNOa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 09:30:26 -0500
Date: Fri, 14 Dec 2007 09:14:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Buesch <mb@bu3sch.de>, Ray Lee <ray-lk@madrabbit.org>,
       bcm43xx-dev@lists.berlios.de, Daniel Walker <dwalker@mvista.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, mbuesch@freenet.de
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
Message-ID: <20071214141446.GA3096@tuxdriver.com>
References: <20071213003028.676998182@mvista.com> <200712131445.39770.mb@bu3sch.de> <2c0942db0712131604m41c34da9hf3122b0603f3af96@mail.gmail.com> <200712140143.16451.mb@bu3sch.de> <20071214105624.GC23964@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214105624.GC23964@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 11:56:24AM +0100, Ingo Molnar wrote:
> 
> * Michael Buesch <mb@bu3sch.de> wrote:

> > Oh come on. b43 is more than a year old now. How long should we wait? 
> > Two or three? Forever?
> 
> possibly forever, if you dont get obvious regressions like "my wlan does 
> not work" (reported in this very thread), resolved. Pushing the blame to 
> udev (in a rather unfriendly way) wont give users a working system and 
> wont get you many new testers for the new driver either.

It is true that Michael can be a little unpleasant at times.
The colloquialism that comes to mind is that he "does not suffer fools
lightly".  Hopefully he will take your counseling to heart and learn
to be a bit more moderate in his tone.  FWIW, he is still young. :-)

That said, it is also true that the b43[legacy] driver[s] do a more
than adequate job of replacing the old bcm43xx driver provided that
one (re-)installs the proper firmware.  And I know of no other driver
that goes to more trouble to tell you how to get the proper firmware
installed than this one.

The bcm43xx driver will be added to the feature removal schedule
in 2.6.25.  Proper judgment will be used in deciding the actual date
of its removal.  In the meantime hopefully every distribution will
have or obtain a working udev configuration.  If things don't work
out as planned then we will re-evaluate.

Let's stop this now please.

John
-- 
John W. Linville
linville@tuxdriver.com
