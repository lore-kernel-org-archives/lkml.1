Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbZGHJft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbZGHJft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 05:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759534AbZGHJf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 05:35:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36903 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665AbZGHJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 05:35:27 -0400
Date: Wed, 8 Jul 2009 11:35:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] accessibility, speakup, speech synthesis & /sys
Message-ID: <20090708093516.GE24385@elf.ucw.cz>
References: <20090625220452.GF5540@const.famille.thibault.fr> <20090630063454.GI1351@ucw.cz> <20090701221904.GA4431@const>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090701221904.GA4431@const>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-07-02 00:19:04, Samuel Thibault wrote:
> Hello,
> 
> Pavel Machek, le Tue 30 Jun 2009 08:34:54 +0200, a écrit :
> > > Then there are the screen reading parameters. I'd tend to think that
> > > like there are /sys/{block,firmware,fs,power}, there could be a
> > > /sys/accessibility, or even shorter, /sys/a11y?  Speakup parameters
> > > could then be in /sys/a11y/speakup?
> > 
> > Please keep a11y and similar madness far from kernel.
> 
> What do you qualify as "madness" precisely?  Could you explain why you
> are using such extreme word?

If the word is so long that you have to write number of its letters
inside... then you are using wrong word.

Greg's suggestion seems ok.

> > /sys/speech ? Or even better /sys/class/speech? What is global about
> > it?
> 
> As I said, there is a difference between speech synthesizers, which can
> easily be considered as devices, and screen readers (here, speakup),
> which could for instance use different synthesizers, so please don't mix
> them. Accessibility features, however, is not really a device, but as it
> was suggested it could go into the vtcon directory.

Ack.

> > BTW... from 486+, cpus are fast enough for speech synthesis. Why not
> > doing it in software, viewing hw synthetisers as 'flite coprocessors'?
> 
> At least because flite is very far from proprietary hardware
> synthesizers in terms of quality.

Well... but for reading boot messages, it might be adequate, right?

> > What modifications would be needed to make useful a11y w/o additional
> > hw?
> 
> It depends on what you call "useful".  The desktop can already use
> software speech synthesis.  When / can't be mounted, you're hosed,
> however, unless you have shipped a full software speech synthesizer in
> initrd, but even in such case the initrd script could also fail.

I'd actually prefer soft synthetiser in initrd. You know... "normal"
consoles (such as vt) do fail sometimes, too.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
