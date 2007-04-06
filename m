Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbXDFV4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbXDFV4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbXDFV4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:56:43 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:46550 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbXDFV4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:56:43 -0400
Date: Fri, 6 Apr 2007 23:53:45 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: David Brownell <david-b@pacbell.net>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ...
 blinky leds!!)
In-Reply-To: <200704061405.50169.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.61.0704062351580.6042@yvahk01.tjqt.qr>
References: <11757099691323-git-send-email-tony@atomide.com>
 <200704061029.55710.david-b@pacbell.net> <46169968.2050006@s5r6.in-berlin.de>
 <200704061405.50169.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 6 2007 14:05, David Brownell wrote:
>
>Please change your coding style to conform to Documentation/CodingStyle.
>
>	***	Only indent with tabs!!		***
>
>Every one of those examples violates that simple rule.
>
>Why does *anyone* have even the slightest difficulty understanding such a
>simple rule?  I realize that two of those words have more than a single
>syllable, but that should not be a problem.  Even EMACS is trainable.

Tabs should be used for indent, not padding. People wanting to use
different-sized tabs can change settings in their editor, i.e.
to make a tab 12 instead of 8. Or 6. Or whatever. If tabs only ever
appear at the front, this works, it breaks when tabs are used to line
up foo->bar=1; foo->boom=17; statements.


Jan
-- 
