Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbYGBXGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbYGBXGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 19:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYGBXGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 19:06:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39061 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbYGBXGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 19:06:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: b43 locks the machine when resuming after suspend to disk
Date: Thu, 3 Jul 2008 01:08:36 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Giacomo Mulas <gmulas@ca.astro.it>, linux-kernel@vger.kernel.org,
       debian-kernel@lists.debian.org,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>
References: <alpine.DEB.1.10.0807021830300.32045@capitanata.ca.astro.it> <200807022340.31894.rjw@sisk.pl> <1215039419.13270.18.camel@johannes.berg>
In-Reply-To: <1215039419.13270.18.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807030108.37614.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of July 2008, Johannes Berg wrote:
> On Wed, 2008-07-02 at 23:40 +0200, Rafael J. Wysocki wrote:
> > On Wednesday, 2 of July 2008, Giacomo Mulas wrote:
> > > I tried searching on the list for this, before posting, but searching the
> > > mailing list archives with keywords such as b43, suspend, resume... brings
> > > up such a ludicrous amount of threads that it's not realistic to check them
> > > all, so just tell me what to look for if it's been asked already.
> > > 
> > > Whenever I do a suspend to disk after using b43, the computer freezes hard
> > > as soon as it attempts again to access b43 after resume.
> > > 
> > > Minimal how to reproduce the freeze:
> > > 1) modprobe b43
> > > 2) hibernate (using any suspend to disk, which one is irrelevant)
> > > 3) resume
> > > 4) ifconfig wlan0 up
> 
> > I think you need the appended patch, but it only applies to linux-next.
> 
> Rafael, you misled me :) This is a completely different thing.

Ah, sorry then.  I was too quick with my response.

Rafael
