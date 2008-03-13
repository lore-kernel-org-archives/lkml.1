Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbYCMKAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbYCMKAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYCMKAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:00:09 -0400
Received: from smtp.regionline.fi ([85.157.255.99]:58742 "EHLO
	smtp.regionline.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbYCMKAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:00:08 -0400
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2008 06:00:07 EDT
From: Jan Knutar <jk-lkml@sci.fi>
To: linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
Date: Thu, 13 Mar 2008 11:48:21 +0200
User-Agent: KMail/1.6.2
Cc: Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
       Jiri Kosina <jkosina@suse.cz>, David Newall <davidn@davidnewall.com>,
       Theodore Tso <tytso@mit.edu>, "Fred ." <eldmannen@gmail.com>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <200803122222.05663.hpj@urpla.net> <1205386933.4797.22.camel@marge.simson.net>
In-Reply-To: <1205386933.4797.22.camel@marge.simson.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803131148.22056.jk-lkml@sci.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 07:42, Mike Galbraith wrote:

> > Just for the record, this problem started with openSUSE 10.2 for
> > me, that's a 2.6.18 thingy. I'm a heavy xterm user, where the
> > autorepeat gets a life of its own _occasionally_. I'm able to stop
> > it by triggering a autorepeat manually (typical antidot reaction).
>
> I've seen these key repeats for years.  All I ever had to do was to
> make X run heavily enough in the presence of another (hefty) load
> that it hits the expired array and thereby takes a serious latency
> hit.  I always considered key repeats under load to be X's quaint way
> of saying "HEEEEELP MEEEE" ;-)

I experience random repeats during heavy loads  such as yum upgrade, 
which triggers a huge swapout, in Fedora Core 7 with Fedora's 
2.6.23.14-64 on amd64, Xorg 1.3... Using USB keyboard.

I'm not sure if it's the same issue or not, they don't repeat "forever" 
for me, it just makes my speeellllliingggg   llllooookkk   
teerrriibbblle. Like that. Before this happens, letters usually stop 
appearing on screen as I'm typing. I usually stop typing at that point, 
since I know it will just become a mess.

I haven't encountered "forever"-stuck keys since about Fedora Core 5, I 
don't remember kernel and X versions there, but I was using a PS/2 
keyboard, and almost always it was something like ctrl-right that 
stuck, which meant that the computer ended up switching virtual 
desktops as fast as it could. Recovery involved bashing on keyboard, 
trying ctrl-alt-backspace, ctrl-alt-f1 and so on until something 
worked. It took many minutes to clear up, with everything trying to 
redraw their windows a few hojillion times. 
I hope this doesn't come back, I can cope with the bad spelling ;-)

