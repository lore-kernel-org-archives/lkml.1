Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbXLZURp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbXLZURp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 15:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbXLZURh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 15:17:37 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37784 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751514AbXLZURg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 15:17:36 -0500
Date: Wed, 26 Dec 2007 21:17:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] sleepy linux
Message-ID: <20071226201722.GC8844@elf.ucw.cz>
References: <20071225230731.GA29030@elf.ucw.cz> <200712261828.04671.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712261828.04671.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-12-26 18:28:04, Oliver Neukum wrote:
> Am Mittwoch, 26. Dezember 2007 00:07:31 schrieb Pavel Machek:
> > Heute 00:07:31
> >    
> > This is RFC. It does not even work for me... it sleeps but it will not
> > wake up, because SATA wakeup code is missing. Code attached for illustration.
> > 
> > I wonder if this is the right approach? What is right interface to the
> > drivers?
> 
> IMHO you are making to many special cases. The system can be "sleepy"
> if all devices can be runtime suspended and all CPUs are idle.

Is there an easy way to tell if all the devices are runtime suspended?

I guess I need to know from atomic context :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
