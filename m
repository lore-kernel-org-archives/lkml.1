Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbZEKMRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbZEKMRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbZEKMQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:16:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51537 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757713AbZEKMQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:16:43 -0400
Date: Sun, 10 May 2009 07:38:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Shannon McMackin <smcmackin@gmail.com>
Cc: linux-kernel@vger.kernel.org, tuxonice-devel@lists.tuxonice.net
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090510053820.GF1363@ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090507120948.GA1531@ucw.cz> <200905080037.19722@centrum.cz> <gu017d$g2s$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gu017d$g2s$1@ger.gmane.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>>> To summarise disadvantages:
>>>
>>> - only core has 8000 LoC
>>> - it does stuff that can be easily done in userspace
>>>     (and that todays distros _do_ in userspace).
>>> - it duplicates uswsusp functionality.
>>> - compared to [u]swsusp, it received little testing
>>>
>>
>> To summarise advatages - for me tuxonice is the only hibernation method that works.
>> (Till now I've had 3 machines - no one of them able to resume with in-kernel swsusp.)
>>
> Just to add my 2 cents as a user of TOI.  Every distro and release I've  
> tried has one major issue with kernel hibernation.  Upon resume when  
> hibernating large images, there's a residual footprint in swap.  Every  
> further hibernation creates a larger footprint, to the order of an  
> additional 5-7% each time.  Nobody has ever cared in any forum to  
> explain why or how I might change that.

Maybe you should explain why it is a 'major issue'?

(Use swapoff -a; swapon -a to 'cure' it).

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
