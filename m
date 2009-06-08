Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbZFHOmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbZFHOmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZFHOl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:41:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41125 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbZFHOl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:41:57 -0400
Date: Mon, 8 Jun 2009 07:56:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Michael S. Zick" <lkml@morethan.org>, Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harald Welte <HaraldWelte@viatech.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Message-ID: <20090608055623.GA1444@ucw.cz>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <e9e943910906040900j6f334f29l42a9f5a57e9a1c8f@mail.gmail.com> <alpine.LFD.2.01.0906040910280.4880@localhost.localdomain> <200906041121.30845.lkml@morethan.org> <alpine.LFD.2.01.0906040948480.4880@localhost.localdomain> <alpine.LFD.2.01.0906041004000.4880@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906041004000.4880@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-04 10:07:37, Linus Torvalds wrote:
> 
> 
> Side note: is it more stable if you disable the VIA speedstep thing 
> (whatever it's called (ok, google tells me it's called "TwinTurbo" and 
> "Advanced PowerSaver")?
> 
> Features like that easily put a huge stress on power regulators etc, if 
> they result in sudden changes in current draw.  Underspecced capacitors 
> etc can cause CPU "brown-outs", which in turn can easily cause total 
> failure. 

If you try that, do idle=poll too. Hides class of bugs related to deep
idle states.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
