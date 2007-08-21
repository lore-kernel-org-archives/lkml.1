Return-Path: <linux-kernel-owner+w=401wt.eu-S1759739AbXHUNni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739AbXHUNni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 09:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757103AbXHUNn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 09:43:28 -0400
Received: from twin.jikos.cz ([213.151.79.26]:47620 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730AbXHUNn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 09:43:27 -0400
Date: Tue, 21 Aug 2007 15:42:26 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Florin Iucha <florin@iucha.net>
cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       trond.myklebust@fys.uio.no
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
 v2.6.23-rc3-50-g28e8351
In-Reply-To: <20070821132704.GJ10422@iucha.net>
Message-ID: <Pine.LNX.4.64.0708211536560.2460@twin.jikos.cz>
References: <20070815133147.GA7124@iucha.net> <Pine.LNX.4.64.0708151647540.2460@twin.jikos.cz>
 <20070815145313.GC7124@iucha.net> <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz>
 <20070821115115.GD10422@iucha.net> <20070821125718.GH10422@iucha.net>
 <Pine.LNX.4.64.0708211502330.2460@twin.jikos.cz> <20070821131759.GI10422@iucha.net>
 <20070821132704.GJ10422@iucha.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Florin Iucha wrote:

> There is another interesting angle to this: in the past, every time I 
> had keyboard problems, it used to be caused by the VFS and/or NFS... 
> after much wrangling, a bunch of bugs were fixed (Hi Trond, Peter, 
> Alan!). Now, after the keyboard "locked up", I used the mouse to close 
> the gnome session, then I logged-in remotely to reboot.  The reboot 
> process locked up and I need to use the reset button!  The second time 
> the keyboard "locked up" I listed my processes, and I noticed that I had 
> a couple of bash processes and a ssh process in "D" state. Something is 
> fishy again in the VFS ;)

Yes, there were some NFS updates in between -rc2 and 
28e8351ac22de25034e048c680014ad824323c65. I'd be now even more curious 
what are you going to find by bisect, please let us know.

I added Trond to CC, full thread to be found at 
http://lkml.org/lkml/2007/8/21/151 for reference.

Florin, it also might be useful to capture the states of stuck processess 
via alt-sysrq-T (or better by echo t > /proc/sysrq-trigger), so that we 
know better where are they stuck.

-- 
Jiri Kosina
