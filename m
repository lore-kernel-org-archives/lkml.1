Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZEZH0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZEZH0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 03:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZEZH0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 03:26:01 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55736 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbZEZH0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 03:26:00 -0400
X-Sasl-enc: dvudGIRzzemrADVKwsRI+PGmLJrjhDAOpOvmw7e2e99r 1243322760
Message-ID: <4A1B9985.5060703@ladisch.de>
Date: Tue, 26 May 2009 09:25:57 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: David Fries <david@fries.net>
CC: David Griffith <dgriffi@cs.csubak.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: bad endpoint address, MOTU FastLane
References: <20090511221203.GB4300@spacedout.fries.net> <4A092B5C.603@ladisch.de> <20090524220756.GC4300@spacedout.fries.net> <4A1A54DB.3090902@ladisch.de> <20090526004146.GD4300@spacedout.fries.net>
In-Reply-To: <20090526004146.GD4300@spacedout.fries.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Fries wrote:
> On Mon, May 25, 2009 at 10:20:43AM +0200, Clemens Ladisch wrote:
> > David Fries wrote:
> > > The MOTU Fastlane device is the only one using QUIRK_MIDI_RAW.  How about
> > > changing the name to QUIRK_MIDI_FASTLANE to imply it isn't completely
> > > generic anymore and adding a comment?
> > 
> > And while we're at it, the driver should claim interface 1 to prevent
> > anyone else from using it.
> 
> Before and after the latest patch snd-usb-audio claims interface 1.

Oops.  Well, that makes the patch easier.  ;-)

> > New patch below.
> > 
> > Are you okay with the tested-by tag?
> 
> Yes, it works.  I'm watching the LEDs blink on the device and data
> come across.

Okay, I'll applay it in the sound tree.


Best regards,
Clemens
