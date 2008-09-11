Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbYIKUWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbYIKUWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYIKUWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:22:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50022 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbYIKUWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:22:22 -0400
Date: Thu, 11 Sep 2008 11:24:10 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Leisner, Martin" <Martin.Leisner@xerox.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       martyleisner@yahoo.com
Subject: Re: FW: [linux-pm] select with timeout across S3
Message-ID: <20080911092408.GA14503@elf.ucw.cz>
References: <556445368AFA1C438794ABDA8901891C09639B7A@USA0300MS03.na.xerox.net> <20080901062513.GA9851@ucw.cz> <556445368AFA1C438794ABDA8901891C0646024D@USA0300MS03.na.xerox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <556445368AFA1C438794ABDA8901891C0646024D@USA0300MS03.na.xerox.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-09-11 02:17:10, Leisner, Martin wrote:
> Hi,
> 
> I finally got 2.6.27-rc5 running...no change in my test program...
> 
> I'm going to look at the patches we're using for 2.4.20/2.6.20...

So the bug is still there, or did 2.6.27-rc5 magically solve the problem?

> marty
> 
> 
> -----Original Message-----
> From: Pavel Machek [mailto:pavel@suse.cz]
> Sent: Mon 9/1/2008 2:25 AM
> To: Leisner, Martin
> Cc: linux-kernel@vger.kernel.org; linux-pm@lists.linux-foundation.org
> Subject: Re: FW: [linux-pm] select with timeout across S3
>  
> Hi!
> 
> > The behavior of linux (in both 2.4.x and 2.6.x) is when the processor
> > sleeps, timeouts on select don't take into account the sleep time,
> > only the run time.
> > 
> > For example, this program should pause for 10 minutes -- however
> > if we go into S3 in the middle its pausing for (10 minutes + time in
> > S3)
> > 
> > I saw this on both 2.6.20 and 2.6.22...
> 
> Can you test this on 2.6.27-rc? We did have some fixes in that
> area....
> 
> 							Pavel
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
