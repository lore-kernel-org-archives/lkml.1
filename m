Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbXKZMQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbXKZMQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 07:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbXKZMQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 07:16:26 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1046 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754351AbXKZMQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 07:16:24 -0500
Date: Sun, 25 Nov 2007 18:32:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Tobias <kaminsky@finswimmer.de>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: [REQUEST] Option for skipping unreadable blocks on Video DVD
Message-ID: <20071125183245.GB5087@ucw.cz>
References: <fa.DNZjDdh1eNcFR2zDRKzQ6G2bIVU@ifi.uio.no> <473FC662.7020901@shaw.ca> <200711182334.52703.kaminsky@finswimmer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711182334.52703.kaminsky@finswimmer.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I think that if they are using the normal block layer accesses on the
> > DVD device, there may be some retries that occur which are likely
> > undesirable in this case since they will just stall playback. If they
> > are using SG_IO to feed raw requests into the drive (which I imagine
> > they need to do for CSS authentication, etc. anyway), then all error
> > handling is passed up to the user application.
> 
> Normal apps like cp are ending because of Input/Output error. 
> I did some researches and 
> dd if=/dev/hdc of=image.iso conv=noerror,sync bs=1M 
> does everything I want for whole Video Dvds. It skips unreadable blocks.
> But I get recorded tv shows from friends and there is the same as with 
> scratched dvds. Now the problem is that there are several .avi files on it. 
> So I cannot use dd. 

dd works with files.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
