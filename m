Return-Path: <linux-kernel-owner+w=401wt.eu-S1763658AbXHPKQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763658AbXHPKQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 06:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbXHPKQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 06:16:21 -0400
Received: from helios.cs.csubak.edu ([136.168.201.112]:53584 "EHLO
	helios.cs.csubak.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbXHPKQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 06:16:20 -0400
Date: Thu, 16 Aug 2007 03:16:07 -0700 (PDT)
From: David Griffith <dgriffi@cs.csubak.edu>
To: Clemens Ladisch <clemens@ladisch.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: MOTU Fastlane USB MIDI interface
In-Reply-To: <20070816093703.sndy0gg44gk0o0ko@webmail.df.eu>
Message-ID: <Pine.GSO.4.55.0708160308450.24052@helios.cs.csubak.edu>
References: <Pine.GSO.4.55.0708100242000.25856@helios.cs.csubak.edu>
 <20070816093703.sndy0gg44gk0o0ko@webmail.df.eu>
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

On Thu, 16 Aug 2007, Clemens Ladisch wrote:

> David Griffith wrote:
> > Does anyone here have or can borrow a MOTU Fastlane USB MIDI
> > interface? I'm having a nasty time trying to nail down what's going
> > wrong.  It seems that for kernels 2.6.17 and earlier, MIDI works fine
> > through this interface.  After that, it doesn't.
>
> What do you mean with "doesn't work"?  Does the kernel detect it?  Does
> it appear in /proc/asound/cards?  What happens if you try to use it?

$ cat /proc/asound/cards
 0 [AudioPCI       ]: ENS1371 - Ensoniq AudioPCI
                      Ensoniq AudioPCI ENS1371 at 0xec00, irq 18
 1 [Fastlane       ]: USB-Audio - Fastlane
                      MOTU Fastlane at usb-0000:00:10.2-1, full speed

$ amidi -l
IO  hw:0,0    ES1371
IO  hw:1,0,0  Fastlane MIDI A
IO  hw:1,0,1  Fastlane MIDI B

$ amidi -d -p hw:1,0,0

At this point I should see two-digit hex numbers in groups of five or six
whenever a key or other control on the midi keyboard is operated.
Nothing happens though.  Oddly enough, nothing happens when I try midi
through the soundcard as well.  Checking further, I've never been able to
get midi to work with kernels 2.6.18 and later.


-- 
David Griffith
dgriffi@cs.csubak.edu

A: Because it fouls the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?
