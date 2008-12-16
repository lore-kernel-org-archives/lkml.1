Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbYLPQW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbYLPQW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbYLPQWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:22:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55603 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbYLPQWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:22:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
Date: Tue, 16 Dec 2008 17:22:40 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <gi247o$iog$1@ger.gmane.org> <200812161713.08451.rjw@sisk.pl> <gi8kc5$m5f$6@ger.gmane.org>
In-Reply-To: <gi8kc5$m5f$6@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161722.41149.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 16 of December 2008, Brian J. Murrell wrote:
> On Tue, 16 Dec 2008 17:13:08 +0100, Rafael J. Wysocki wrote:
> > 
> > Hm, this really isn't reasonable.
> 
> Many people agree with you.  :-)  There is a long bug open with ubuntu to 
> restore this s2ram.  They seem to be ignoring it though.
> 
> > s2both saves the image, which takes
> > quite a lot of time, while s2ram doesn't.
> 
> Indeed.
>  
> > You can compile s2ram from sources, it's not too difficult.
> 
> Yeah.  I will probably just grab the debian package and dpkg-buildpackage 
> it on my Ubuntu system.
>  
> > Hm.  Is that all loaded when you boot with init=/bin/bash (by which I
> > mean the minimal config)?
> 
> It sure is.  Most assuredly by the initrd.  Debian/Ubuntu systems seem to 
> put everything but the kitchen sink into their initrds.  Which on the one 
> hand makes them pretty portable and resilient, but on the other, yes, 
> bloated.

Well, please remove as many modules as you can (using rmmod) and see if your
second resume still fails.

Thanks,
Rafael
