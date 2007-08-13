Return-Path: <linux-kernel-owner+w=401wt.eu-S1763143AbXHMUqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763143AbXHMUqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947981AbXHMUpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:45:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37638 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S943027AbXHMUpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:45:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: resume from ram much slower
Date: Mon, 13 Aug 2007 22:55:33 +0200
User-Agent: KMail/1.9.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Arkadiusz Miskiewicz <arekm@maven.pl>, linux-kernel@vger.kernel.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
References: <200708101848.37222.arekm@maven.pl> <6bffcb0e0708101034x44ef5bd0we6a94e398c30c511@mail.gmail.com> <20070813195507.GB18731@elf.ucw.cz>
In-Reply-To: <20070813195507.GB18731@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708132255.34572.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 13 August 2007 21:55, Pavel Machek wrote:
> Hi!
> 
> > [S-T-R wizards CC'ed]
> > 
> > On 10/08/07, Arkadiusz Miskiewicz <arekm@maven.pl> wrote:
> > > Hi,
> > >
> > > Starting 1-2 weeks ago I have very long resume from
> > > ram times. It takes more than 1 min to resume. Does anyone see such behaviour?
> > >
> > > Kernel from yesterday git, thinkpad z60m, suspend.sf.net tools 20070801
> > >
> > > "ACPI handle has no context!" are interesting btw.
> 
> 
> Usual way to debug it is to unload as many modules as possible, to
> find out if it is caused by one of them...

This particular message only means that the device is unknown to ACPI and its
power state should be set to D3 (or equivalent).  PCI handles this correctly,
pnp also seems to handle it and there are no more users.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
