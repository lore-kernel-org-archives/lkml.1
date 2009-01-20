Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbZATNAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbZATNAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbZATNAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:00:31 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:34343 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbZATNAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:00:30 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4975CAF5.9090607@cam.ac.uk>
Date: Tue, 20 Jan 2009 13:00:37 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@kernel.org>
Subject: Re: regulator: Add always off to constraints.
References: <4975BE69.5040106@cam.ac.uk> <20090120124338.GA31521@sirena.org.uk>
In-Reply-To: <20090120124338.GA31521@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Tue, Jan 20, 2009 at 12:07:05PM +0000, Jonathan Cameron wrote:
> 
>> 1) interaction between always on and always off.  Obviously it's
>> a bit odd if both are set. Currently I'm giving always on preference.
> 
> I'd just complain loudly and refuse to accept the constraints if they
> are clearly broken like that.
Will do.
> 
> One thing I would suggest is a slightly weaker version which marks the
> regulator to be turned off at boot rather than always off.  That's
> slightly more flexible and would achieve the same effect if the
> constraints don't otherwise allow for turning the regulator on layer.
Good idea. That should just mean removing the code in the enable bit 
(and renaming the variable!) I'll repost shortly.
> 
>> 2) Doesn't really make sense to have regulators that are always
>> disabled available under sysfs etc.  Perhaps there is a lower
>> level way of doing this that I'm missing?  There is not easy
>> way of permanently saving this stuff on the da9030 that I'm
>> using and moving it into the bootloader would be a pain.
> 
> It doesn't do *that* much harm - if nothing else it makes it more
> discoverable what's happening.
Good point.
 
Thanks for the comments,

Jonathan
