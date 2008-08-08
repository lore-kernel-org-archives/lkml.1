Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbYHHHw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbYHHHw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 03:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbYHHHw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 03:52:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2609 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753197AbYHHHw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 03:52:26 -0400
Date: Fri, 8 Aug 2008 09:14:30 +0200
From: Pavel Machek <pavel@suse.cz>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Tyan S2923-E suspend to ram fails to resume
Message-ID: <20080808071430.GA10370@ucw.cz>
References: <48977AF7.2070300@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48977AF7.2070300@simon.arlott.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-08-04 22:56:07, Simon Arlott wrote:
> My system (Tyan S2923-E, dmesg attached) suspends ok in 
> all pm_test modes, but it won't resume with pm_test 
> "none".
> 
> [    6.423515] mem full: hash matches
> 
> When I press the power button, the port 80 display shows:
> FF D0 23 01 D0 ... DE
> (and again each time I press it)
> 
> If I force it to turn off, then on again:
> FF D0 23 01 D0 ... FF D0 23 01 D0 ... (D2?) D3 00 01 D5 
> D6 <normal boot>
> 
> Any ideas? (onboard SAS is disabled, watchdog is 
> disabled, everything else is enabled, PCI-E graphics 
> card)

Try verifying if it reaches assembly code under realmode/ ...


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
