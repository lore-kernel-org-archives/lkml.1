Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbYABNHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbYABNHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYABNHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:07:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41306 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbYABNHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:07:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Hesse <mail@earthworm.de>
Subject: Re: [Suspend2-devel] Reboot problem
Date: Wed, 2 Jan 2008 14:09:03 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: nigel@nigel.suspend2.net, suspend2-devel@lists.tuxonice.net,
       "The place to get help!" <suspend2-users@lists.tuxonice.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <477AC060.5040004@nigel.suspend2.net> <477AD38C.6030206@nigel.suspend2.net> <200801020124.13935.mail@earthworm.de>
In-Reply-To: <200801020124.13935.mail@earthworm.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801021409.04682.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of January 2008, Christian Hesse wrote:
> On Wednesday 02 January 2008, Nigel Cunningham wrote:
> > Hi Christian.
> >
> > Christian Hesse wrote:
> > > On Tuesday 01 January 2008, Nigel Cunningham wrote:
> > >> Third, regarding the patch itself, I'm taking my time in working towards
> > >> the 3.0 release. We don't have any major bugs with 3.0-rc3 reported
> > >> [...].
> > >
> > > Well, I think I still have a bug, though it is possibly a mainline
> > > problem and it's not a showstopper. After a suspend/resume cycle the
> > > reboot does not work. The system hangs with "Rebooting system" (or
> > > similar). After that you have to hard reset the system, which is not
> > > really a problem as filesystems have been unmounted before. Reboot
> > > without a suspend cycle before and halt with and without suspend cycle
> > > work without problems.
> >
> > Just to clarify, do you mean rebooting after writing an image, or
> > shutting down and rebooting? It could be that there's some change to the
> > semantics in 2.6.24 that I haven't noticed yet.
> 
> I speak about shutting down and rebooting. I have not used reboot after 
> writing an image for a long time now. Will test what happens in this case.
> 
> I had the issue before 2.6.24(-rc) already, thought I don't know whether there 
> were times it worked. I use it way too seldom.

Well, this is similar to http://bugzilla.kernel.org/show_bug.cgi?id=6655 ,
which definitely is a mainline problem (still pending).

Greetings,
Rafael\
