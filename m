Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbXG2MWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbXG2MWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 08:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761577AbXG2MWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 08:22:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47749 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760024AbXG2MWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 08:22:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/2] Introduce CONFIG_HIBERNATION and CONFIG_SUSPEND (was: CONFIG_SUSPEND?)
Date: Sun, 29 Jul 2007 12:20:13 +0200
User-Agent: KMail/1.9.5
Cc: Len Brown <lenb@kernel.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <200707282029.03563.rjw@sisk.pl> <alpine.LFD.0.999.0707281130110.3442@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707281130110.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707291220.14880.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 28 July 2007 20:31, Linus Torvalds wrote:
> 
> On Sat, 28 Jul 2007, Rafael J. Wysocki wrote:
> > 
> > OK, I'll prepare a patch to introduce CONFIG_SUSPEND, but that will require
> > quite a bit of (compilation) testing on different architectures.
> 
> Sure. I'm not too worried, the fallout should be of the trivial kind. 
>
> Also, mind basing it on the (independent) cleanups that Adrian already 
> sent out. This is all intertwined..

OK, it took more time than I had hoped, but I wanted CONFIG_HIBERNATION and
CONFIG_SUSPEND to be really independent of each other.

The two patches in the next messages implement the idea:
* replace CONFIG_SOFTWARE_SUSPEND with CONFIG_HIBERNATION
* introduce CONFIG_SUSPEND that selects CONFIG_HOTPLUG_CPU, if necessary,
  and make it possible to choose suspend and hibernation independently of each
  other.

Greetings,
Rafael

