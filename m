Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbYBTKQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbYBTKQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 05:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762528AbYBTKQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 05:16:31 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58744 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762471AbYBTKQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 05:16:30 -0500
Date: Wed, 20 Feb 2008 11:16:29 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Karl Dahlke <eklhad@comcast.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: adapter, what's in a name
In-Reply-To: <20080119181606.eklhad@comcast.net>
Message-ID: <Pine.LNX.4.64.0802201106521.26109@fbirervta.pbzchgretzou.qr>
References: <20080119181606.eklhad@comcast.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 19 2008 18:16, Karl Dahlke wrote:
>
>I completely understand your point about the word adapter.
>It is highly overloaded, to the point that it is almost meaningless.
>How about "accessibility"?
>Drivers and modules designed to make linux more accessible
>could be placed in drivers/accessibility in the source tree.
>It's just a suggestion.
>If there is a better word for this concept, please let me know.

Yes, that does not sound bad. It is a common term in the redmond os,
and I think I even saw it in the kde control center last time I used
that.

>And I finally understand what you are trying to say about /proc.
>Processes, and perhaps memory and raid by extension,

RAID is in /sys/block/md*/md  ;-)

>but not everything under the planet.
>Would it be better for accessibility drivers to create files through sysfs, e.g.
>/sys/accessibility/jupiter/synth
>Naturally the jupiter subtree would appear when that module was loaded,
>and disappear when it was removed.

Naturally, just like it would in procfs.

>One person said, essentially,
>"We'll worry about this when the first such driver comes along."
>But that's a chicken egg problem, isn't it?

To a given extent yes, because procfs code is somewhat different
from sysfs is somewhat different from a character-based device.
(Maybe you also want to have both a device and a sysfs file, like md.)

>Let's set it up now, so things have a place to be.
>Besides, speakup has been around for a long long time,
>and jupiter almost as long.
>These have both been converted to use the new notifiers,
>along with pcclicks (sounds accompanying console output),
>halfqwerty (one handed typing), and others.

(Mentioning "halfqwerty" reminds me of Sony's 13-key Thumb Phrase "IM".)

>Many of these will not need any virtual files, but some will,
>and they need a place to be.
>Beyond this, the software should exist somewhere, someday, in the source tree.
>Not every driver under the sun, but some of them,
>that have proved their merit, and meet the high standard of Linux coding, etc.
>Mac comes bundled with an internal screen reader,
>and windows has had an accessibility section for a long time, why not linux?

What accessibility functions does Windows have that Linux (in
general, things are usually implemented only in X or KDE) does not?

>This is the best operating system in so many ways;
>let's not be behind when it comes to accessibility.
