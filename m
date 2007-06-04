Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbXFDNzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbXFDNzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbXFDNzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:55:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48681 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752031AbXFDNy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:54:59 -0400
Date: Mon, 4 Jun 2007 15:54:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <ak@suse.de>
Cc: Jiri Kosina <jikos@jikos.cz>, kernel list <linux-kernel@vger.kernel.org>,
       dmitry.torokhov@gmail.com
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Message-ID: <20070604135427.GA19466@elf.ucw.cz>
References: <20070604112426.GA2707@elf.ucw.cz> <20070604130903.GC1971@elf.ucw.cz> <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz> <200706041543.49071.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706041543.49071.ak@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Are you sure that it's this dummy blink driver that makes the kernel
> > stuck? I can't see how it could be causing any hogs - see commit f038f9.
> >
> > Anyway, added Andi to CC.
> 
> Hmm, in theory it could be triggering bugs in some buggy keyboard
> controller. But then a 
> 
> while true ; do setleds +caps +numlock ; sleep 1 ; setleds -caps -numlock ; 
> sleep 1 ; done
> 
> should trigger it too.

...and it does.

pavel@amd:~$ while true; do setleds +num; setleds -num; done
Hm,m so thiis  iis  a teest of fkeyboarad behaviour  under lloadd.

pavel@amd:~$

...but I'm not quite sure it is a buggy keyboard. It happens _way_ too
often. Launch the line above and try to do some typing...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
