Return-Path: <linux-kernel-owner+w=401wt.eu-S1751370AbZGAW5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbZGAW5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 18:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZGAW5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 18:57:06 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:40666 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZGAW5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 18:57:05 -0400
X-Greylist: delayed 1852 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2009 18:57:05 EDT
Date: Thu, 2 Jul 2009 00:19:04 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] accessibility, speakup, speech synthesis & /sys
Message-ID: <20090701221904.GA4431@const>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
References: <20090625220452.GF5540@const.famille.thibault.fr> <20090630063454.GI1351@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090630063454.GI1351@ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Pavel Machek, le Tue 30 Jun 2009 08:34:54 +0200, a écrit :
> > Then there are the screen reading parameters. I'd tend to think that
> > like there are /sys/{block,firmware,fs,power}, there could be a
> > /sys/accessibility, or even shorter, /sys/a11y?  Speakup parameters
> > could then be in /sys/a11y/speakup?
> 
> Please keep a11y and similar madness far from kernel.

What do you qualify as "madness" precisely?  Could you explain why you
are using such extreme word?

> /sys/speech ? Or even better /sys/class/speech? What is global about
> it?

As I said, there is a difference between speech synthesizers, which can
easily be considered as devices, and screen readers (here, speakup),
which could for instance use different synthesizers, so please don't mix
them. Accessibility features, however, is not really a device, but as it
was suggested it could go into the vtcon directory.

> BTW... from 486+, cpus are fast enough for speech synthesis. Why not
> doing it in software, viewing hw synthetisers as 'flite coprocessors'?

At least because flite is very far from proprietary hardware
synthesizers in terms of quality.

> What modifications would be needed to make useful a11y w/o additional
> hw?

It depends on what you call "useful".  The desktop can already use
software speech synthesis.  When / can't be mounted, you're hosed,
however, unless you have shipped a full software speech synthesizer in
initrd, but even in such case the initrd script could also fail.

Samuel
