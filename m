Return-Path: <linux-kernel-owner+w=401wt.eu-S966190AbXDGRqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966190AbXDGRqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933634AbXDGRqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:46:37 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35260
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbXDGRqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:46:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: Kernel NULL pointer when loading bcm43xx-mac80211 =?iso-8859-1?q?with=09fwpostfix_=3D?= ".fw4"
Date: Sat, 7 Apr 2007 19:45:30 +0200
User-Agent: KMail/1.9.5
Cc: Johannes Berg <johannes@sipsolutions.net>, bcm43xx-dev@lists.berlios.de,
       "linux-kernel, " <linux-kernel@vger.kernel.org>
References: <4616DF5A.7040800@lwfinger.net> <1175958655.8459.8.camel@johannes.berg> <4617D862.7010202@lwfinger.net>
In-Reply-To: <4617D862.7010202@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704071945.30680.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 April 2007 19:44, Larry Finger wrote:
> Johannes Berg wrote:
> > On Sat, 2007-04-07 at 15:51 +0200, Michael Buesch wrote:
> >> On Saturday 07 April 2007 02:01, Larry Finger wrote:
> >>> The current mb and wireless-dev git trees both get a kernel NULL pointer in "param_set_copystring" 
> >>> when modprobe'ing bcm43xx-mac80211 with a line of 'options bcm43xx-mac80211 fwpostfix = ".fw4"' in 
> >>> /etc/modprobe.conf.local. This construction used to work and still does for bcm43xx-softmac. I 
> >>> compared the code between the two versions and cannot see any real differences. Any suggestions?
> >> Uhm, fwpostfix=.fw4 works fine for me when I pass it to modprobe.
> > 
> > I use
> > $ cat /etc/modprobe.d/bcm43xx 
> > options bcm43xx-mac80211 fwpostfix=-v4
> > options bcm43xx_mac80211 fwpostfix=-v4
> > options bcm43xx fwpostfix=-v3
> > 
> > and it works great.
> 
> My bad. As shown above, I had white space around the equals - a no-no. Removing it fixed the 
> problem. The examples both of you showed gave me the clue.

Hm, probably a bug in the modparam subsystem, though.
I'd say it shouldn't crash, at least.

-- 
Greetings Michael.
