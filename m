Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbZGAJDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbZGAJDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZGAJDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:03:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58646 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbZGAJDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:03:15 -0400
Date: Tue, 30 Jun 2009 08:34:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] accessibility, speakup, speech synthesis & /sys
Message-ID: <20090630063454.GI1351@ucw.cz>
References: <20090625220452.GF5540@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625220452.GF5540@const.famille.thibault.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-06-26 00:04:52, Samuel Thibault wrote:
> Hello,
> 
> Just as a reminder, Speakup is an in-kernel screen reader that uses
> hardware speech synthesis to say what gets printed on the Linux console.
> 
> In the process of cleaning it, we are moving its configuration stuff
> into proper places.  I believe there are two things:
> 
> - per- harware speech synthesizer parameters (e.g. speed, pitch, etc.)
> - screen reading parameters (e.g. characters pronunciation, key_echo,
>   current synthesizer being used etc.)
> 
> Speech synthesizers should probably have their own device class, how
> should it be called? "synth"? "speech"?

speech. 'synth' sounds like something midi-related. 

> Synthesizers are usually plugged on serial ports, but there is no bus
> abstraction for that, so I believe we can put them in the virtual bus.
> 
> Then there are the screen reading parameters. I'd tend to think that
> like there are /sys/{block,firmware,fs,power}, there could be a
> /sys/accessibility, or even shorter, /sys/a11y?  Speakup parameters
> could then be in /sys/a11y/speakup?

Please keep a11y and similar madness far from kernel. /sys/speech ? Or
even better /sys/class/speech? What is global about it?

BTW... from 486+, cpus are fast enough for speech synthesis. Why not
doing it in software, viewing hw synthetisers as 'flite coprocessors'?

What modifications   would be needed to make useful a11y w/o
 additional hw?

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
