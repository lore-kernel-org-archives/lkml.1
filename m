Return-Path: <linux-kernel-owner+w=401wt.eu-S935539AbXHJKRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935539AbXHJKRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 06:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935332AbXHJKR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 06:17:28 -0400
Received: from helios.cs.csubak.edu ([136.168.201.112]:52814 "EHLO
	helios.cs.csubak.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935306AbXHJKR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 06:17:27 -0400
X-Greylist: delayed 2090 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2007 06:17:27 EDT
Date: Fri, 10 Aug 2007 02:42:34 -0700 (PDT)
From: David Griffith <dgriffi@cs.csubak.edu>
To: linux-kernel@vger.kernel.org
Subject: MOTU Fastlane USB MIDI interface
Message-ID: <Pine.GSO.4.55.0708100242000.25856@helios.cs.csubak.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5 (--)
X-Spam-Report: ---- Start Spam Filter Report
	Filter Analysis score is (-2.5/5.0)
	-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
	---- End Spam Filter results
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Does anyone here have or can borrow a MOTU Fastlane USB MIDI interface?
I'm having a nasty time trying to nail down what's going wrong.  It seems
that for kernels 2.6.17 and earlier, MIDI works fine through this
interface.  After that, it doesn't.  Most bizarrely the Dynebolic distro,
which is designed specifically for music, doesn't work with this
interface.  This leads me to believe that something changed with 2.6.18
that the MOTU Fastlane didn't like, but doesn't bother other USB MIDI
interfaces.

Here are some notes from my bugtracking:

Doesn't Work:
===============
Dynebolic (kernel 2.6.18, ALSA 1.0.12rc1)
Ubuntu 7.04 (feisty faun) kernel 2.6.20-16
Fedora 7 (kernel 2.6.21)

Works:
======
Gentoo 2006.1 i686 Live CD (kernel 2.6.17)
 If the interface is attached at bootup, one gets "cannot determine
 device number: Inappropriate ioctl for device".  After unplugging, then
 replugging a couple times, midi works ok.
Ubuntu 6.10 (edgy eft) (kernel 2.6.17, ALSA 10.12rc1)
Knoppix 4.0


-- 
David Griffith
dgriffi@cs.csubak.edu
