Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbZEUMIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbZEUMIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 08:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZEUMIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 08:08:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60410 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZEUMIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 08:08:30 -0400
Date: Thu, 21 May 2009 14:08:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] lis3: remove automatic shutdown of the device
Message-ID: <20090521120825.GH2637@elf.ucw.cz>
References: <4A151E9F.1080405@tremplin-utc.net> <4A151F52.3050908@tremplin-utc.net> <20090521113618.GF2637@elf.ucw.cz> <4A15411F.3050704@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A15411F.3050704@tremplin-utc.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> After measurement on my laptop, it seems that turning off the device
> >> does not bring any energy saving (within 0.1W precision). So let's keep
> >> the device always on. It simplifies the code, and it avoids the problem
> >> of reading a wrong value sometimes just after turning the device on.
> > 
> > Well, 0.1W is still quite much for cellphone etc... but as we do not
> > have any such small users in the tree, I guess this can go in...
> > 
> Yes. BTW, what I meant is that the power consumption on my laptop can be
> read with 0.1W precision. Turning on and off the device showed 0.0W
> variations. The device should using even much less than 0.1W. According
> to the documentation, it's about 2.2mW when on and 3?W when off.

2mW would be still significant on a cellphone, draining battery in cca
20 days (which is about as bad as GSM radio), but...

If cellphone user comes, he can simply recreate powersaving code...

Feel free to add 

Signed-off-by: Pavel Machek <pavel@ucw.cz> 

to 2,3/4. ... And btw 4/4 probably could be pushed to 2.6.30. It is
trivial enough... and "new hw" support is okay even late in cycle.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
