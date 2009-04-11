Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZDKKwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZDKKwg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 06:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbZDKKw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 06:52:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33764 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbZDKKw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 06:52:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: suspend-to-ram broken on X61 thinkpads in 2.6.30-rc1?
Date: Sat, 11 Apr 2009 12:51:48 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-rjw; KDE/4.2.2; x86_64; ; )
Cc: tytso@mit.edu, Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
References: <E1Ls9pZ-0004IF-FZ@closure.thunk.org> <900814656-1239422746-cardhu_decombobulator_blackberry.rim.net-2124207137-@bxe1152.bisx.prod.on.blackberry> <b6a2187b0904102158r5e37860cw2f45bee5578ebcf0@mail.gmail.com>
In-Reply-To: <b6a2187b0904102158r5e37860cw2f45bee5578ebcf0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904111251.49396.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 April 2009, Jeff Chua wrote:
> On Sat, Apr 11, 2009 at 12:04 PM, Theodore Tso <tytso@mit.edu> wrote:
> > So I tried to do a bisect using a reduced config, and I wasn't able to reproduce.  So I went back to 2.6.30-rc1 and started playing with configurations.   I was able to finally get a reproduction, and I found that the af_packet module seems to be responsible.   If I move the modules directory out of the way and reboot, then manually insmod the af_packet module, then suspend, it fails by hanging with the flashing moon LED.  If I reboot and don't load the af_packet module, the suspend works.   Needless to say this falls into the WTF category.   I will do more testing to see what's up...
> 
> Latest linux git-pull seems to fix the problem. Suspend-to-ram and
> resume now works. I've tried a few times and it works. Reverting the
> patch makes it hang during suspend.
> 
> Latest git pull from 62b8e680e61d3f48f2a12ee248ca03ea8f376926 to
> d848223808c5d21e1b3cea090047e34722c6254b

Great, thanks for checking this.

Ted, can you please see if the current -git fixed the problem for you too?

Rafael
