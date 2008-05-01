Return-Path: <linux-kernel-owner+w=401wt.eu-S1761156AbYEAQXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156AbYEAQXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYEAQXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:23:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58941 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYEAQXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:23:10 -0400
Date: Thu, 1 May 2008 18:23:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
Message-ID: <20080501162330.GG26085@elf.ucw.cz>
References: <4815E9AD.50601@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4815E9AD.50601@rtr.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> Something like this will close the window to right up until the point
>>> where the other CPUs have 'almost' called halt().
>>
>> Now I took a look at context... why not simply use same trick swsusp
>> uses, and do a hot unplug of all cpus at the end of shutdown?
> ..
>
> That's the current existing workaround for this bug,
> but not everybody has cpu hotplug in their config,
> and this bug should still get fixed.

Ok... alternative solution is to keep cpu hotplug always
enabled. Suspend & hibernation seems to need it, anyway, and
dupliating code between cpu hotplug and shutdown does not look _that_
attractive.


									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
