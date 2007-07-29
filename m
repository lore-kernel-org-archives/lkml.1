Return-Path: <linux-kernel-owner+w=401wt.eu-S936452AbXG2VWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936452AbXG2VWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935387AbXG2VV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:21:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49391 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765857AbXG2VV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:21:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/2] Introduce CONFIG_HIBERNATION and CONFIG_SUSPEND (updated)
Date: Sun, 29 Jul 2007 23:23:28 +0200
User-Agent: KMail/1.9.5
Cc: Len Brown <lenb@kernel.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <alpine.LFD.0.999.0707281130110.3442@woody.linux-foundation.org> <200707291220.14880.rjw@sisk.pl>
In-Reply-To: <200707291220.14880.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707292323.29601.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 July 2007 12:20, Rafael J. Wysocki wrote:
> On Saturday, 28 July 2007 20:31, Linus Torvalds wrote:
> > 
> > On Sat, 28 Jul 2007, Rafael J. Wysocki wrote:
> > > 
> > > OK, I'll prepare a patch to introduce CONFIG_SUSPEND, but that will require
> > > quite a bit of (compilation) testing on different architectures.
> > 
> > Sure. I'm not too worried, the fallout should be of the trivial kind. 
> >
> > Also, mind basing it on the (independent) cleanups that Adrian already 
> > sent out. This is all intertwined..
> 
> OK, it took more time than I had hoped, but I wanted CONFIG_HIBERNATION and
> CONFIG_SUSPEND to be really independent of each other.
> 
> The two patches in the next messages implement the idea:
> * replace CONFIG_SOFTWARE_SUSPEND with CONFIG_HIBERNATION
> * introduce CONFIG_SUSPEND that selects CONFIG_HOTPLUG_CPU, if necessary,
>   and make it possible to choose suspend and hibernation independently of each
>   other.

Unfortunately, the patches that I have posted are against 2.6.23-rc1 with the
suspend and hibernation patchset applied
(http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.23-rc1/patches/) .

Sorry for that.

The corresponding patches on top of the current -git are in the next two
messages.

They do the following:
* replace CONFIG_SOFTWARE_SUSPEND with CONFIG_HIBERNATION
* introduce CONFIG_SUSPEND that selects CONFIG_HOTPLUG_CPU, if necessary,
  and make it possible to choose suspend and hibernation independently of each
  other
* update the top-level PM-related headers and the ACPI code related to suspend
  and hibernation to use the new definitions

Greetings,
Rafael

