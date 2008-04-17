Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbYDQJ67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbYDQJ67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934087AbYDQJbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:31:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49409 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934076AbYDQJbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:31:45 -0400
Date: Thu, 17 Apr 2008 11:32:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: Self-snapshotting in Linux
Message-ID: <20080417093235.GB7314@elf.ucw.cz>
References: <ajbvb-3Ur-21@gated-at.bofh.it> <ajcri-65w-13@gated-at.bofh.it> <da08e304-eb95-4ace-a069-de1a57b86e9f@e39g2000hsf.googlegroups.com> <20080416111237.GA32432@atrey.karlin.mff.cuni.cz> <48060436.6030707@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48060436.6030707@tuffmail.co.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-04-16 14:50:46, Alan Jenkins wrote:
> Pavel Machek wrote:
>>> I guess there is the hardware / drivers issue.  I would like to claim
>>> I've found hibernation to be reliable but unfortunately that's not
>>> 100% true.
>>>     
>> So debug it, it is open source after all. Or at least file a bugs.
>>   
> I definitely want to debug it; I love hibernating.  It's a regression and 
> it'll affect my distro kernel once I upgrade to Ubuntu Hardy.
>
> <http://bugzilla.kernel.org/show_bug.cgi?id=10196> "Backtraces during 
> hibernate / resume".
>
> I posted the backtraces but nobody could tell me what they were - they 
> don't actually say whether they're OOPs or BUGs etc.  They might be 
> softlockups - some times I got softlockup warnings, though thats not in the 
> log I posted.

Not sure what that is, I never seen that before.

Can you try vanilla 2.6.25-rc9 or something?

> I'm confused about some details (exactly which versions / configs produced 
> which symptoms).  I don't have the machine right now, but I'll get back to 
> it some time soon.  I think I managed to get a pair of broken and 
> non-broken kernels to work on, and it seems to be a regression going from 
> 2.6.22 to 2.6.23.

If you can do a git bisect between those two, we could probably fix it
very quickly.

> Any help in clearing up my confusion would be appreciated.  Is it worth 
> trying to narrow down exactly where the hang happens between writing the 
> hibernation image and shutting down?  If so how?  I suspect that's going to 
> be easier than bisecting it.

Adding printks?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
