Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbXJXQTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbXJXQTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbXJXQTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:19:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4134 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752268AbXJXQTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:19:09 -0400
Date: Thu, 11 Oct 2007 20:54:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>, nigel@suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       linux-pm@lists.linux-foundation.org,
       huang ying <huang.ying.caritas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Message-ID: <20071011205445.GA3975@ucw.cz>
References: <Pine.LNX.4.44L0.0709211540100.5816-100000@iolanthe.rowland.org> <BF08447B-234F-4851-89BF-92A57EA801C6@mac.com> <200709220947.58872.nigel@nigel.suspend2.net> <200709221240.25614.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709221240.25614.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > That's certainly possible. We already pass a very small amount of data between 
> > the boot and resuming kernels at the moment, and it's done quite simply - by 
> > putting the variables we want to 'transfer' in a nosave page/section.
> 
> Well, if the boot and image kernels are different, which is now possible on
> x86_64 with some recent patches (currently in -mm), the nosave trick won't
> work.

I guess we should remove the nosave.... at least from x86-64. If
someone tries to use it, he'll get a nasty surprise.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
