Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbYIZMrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbYIZMrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYIZMq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:46:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60656 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbYIZMqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:46:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Iwo Mergler <iwo@call-direct.com.au>
Subject: Re: Bug in rt2x00 rt73usb driver in latest git kernel
Date: Fri, 26 Sep 2008 14:52:27 +0200
User-Agent: KMail/1.9.9
Cc: Paul Eddington <eddingtonpaul@googlemail.com>,
       linux-kernel@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <762793250809241102n61ea8f00kca8138bc3c8df2e6@mail.gmail.com> <48DC734B.8070805@call-direct.com.au>
In-Reply-To: <48DC734B.8070805@call-direct.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809261452.28482.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 26 of September 2008, Iwo Mergler wrote:
> Paul Eddington wrote:
> > Hi,
> > 
> > While running the latest git kernel (linus' tree) and using a usb wifi
> > card, I got this error in dmesg:;
> > 
> > phy2 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry
> > in the non-full queue 2.
> > Please file bug report to http://rt2x00.serialmonkey.com.
> > 
> > This is not reproducible easily, but it has occurred on two occasions
> > both while connected to a WEP encrypted AP with a 40-bit key and
> > performing many file samba transfers at full speed 54mbits.
> > 
> > I tried to report the bug there but was unable to register and edit
> > the bug reports wiki page.
> > If there is any more information or help required to debug this,
> > please let me know.
> > 
> > Regards,
> > Paul
> > --
> 
> Hi Paul,
> 
> the rt2x00 drivers are currently a very fast moving target. You may want
> to experiment with the rt2x00 kernel tree instead - it gets the patches
> (and the bugs) earlier. ;-)
> 
> http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=summary
> 
> I added the rt2x00 mailing list to CC.

Well, according to the information I've received from Paul this particular
problem is a regression from 2.6.26, so it's been added to the list of recent
regressions.

Thanks,
Rafael
