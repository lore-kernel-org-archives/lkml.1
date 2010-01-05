Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536Ab0AEXEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab0AEXEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 18:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394Ab0AEXEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 18:04:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34529 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418Ab0AEXEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 18:04:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
Subject: Re: [linux-pm] [suspend/resume] Re: userspace notification from module
Date: Wed, 6 Jan 2010 00:05:17 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Anders Eriksson <aeriksson@fastmail.fm>,
       Stefan Seyfried <stefan.seyfried@googlemail.com>,
       linux-pm@lists.linux-foundation.org, danborkmann@googlemail.com,
       awalls@radix.net
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <20100105222657.27218c4c@strolchi.home.s3e.de> <11f818a7.4b53f68a.4b43bb9b.b3a7f@o2.pl>
In-Reply-To: <11f818a7.4b53f68a.4b43bb9b.b3a7f@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001060005.17246.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010, Bartłomiej Zimoń wrote:
> Dnia 5 stycznia 2010 22:26 	Stefan Seyfried <stefan.seyfried@googlemail.com> napisał(a):
> > On Tue, 05 Jan 2010 10:07:06 +0100
> > Anders Eriksson <aeriksson@fastmail.fm> wrote:
> > 
> > > 
> > > rjw@sisk.pl said:
> > > >> > I don't see a problem with this in principle, although I don't think signals
> > > >> > are very suitable for this particular purpose, because you need two-way
> > > >> > communication between the power manager and the processes it's going to
> > > >> > notify (because it has to wait for the processes to finish their preparations
> > > >> > and to tell it that they are ready). 
> > > 
> > > Wouldn't there need to be dependecy tracking for the userspace processes? A 
> > > process couldn't signal "done" until it know there's no more work to do, which 
> > > requires all other processes to finish up first.
> > 
> > No. 99% of the processes don't care about suspend. They don't need
> > notifications or anything.
> > The few that do care, register themselves with the power manager. They
> > get notified before suspend and the power manager might wait until they
> > tell him that they are ready.
> > A special case are processes that only want to inhibit suspend - the CD
> > burning application case - they just tell the power manager "I am
> > important and you must not suspend now". They do this even if there is
> > no suspend notification, and once they are done with the critical part
> > of their work, they remove their "inhibit flag".
> > 
> > This all works pretty well already, and is really not very complicated.
> 
> So pm could be very simple, and i think we don't need more.
> I want ask You how usualy such user (not root) process notification is done,
> You are talking about pm-utils right?

Well, I think you have some specific issue with pm-utils, but you're not
telling us what it is.  So, why exactly is pm-utils not suitable for your
needs?

Rafael
