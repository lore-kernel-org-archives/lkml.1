Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbZBIJr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbZBIJr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZBIJrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:47:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51842 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZBIJrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:47:49 -0500
Date: Mon, 9 Feb 2009 10:47:48 +0100
From: Pavel Machek <pavel@suse.cz>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: ?ric Piel <eric.piel@tremplin-utc.net>, linux-kernel@vger.kernel.org,
       Palatis Tseng <palatis@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
Message-ID: <20090209094748.GC4358@atrey.karlin.mff.cuni.cz>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com> <498D9F02.9000107@tremplin-utc.net> <cb7bb73a0902071559w70b3367el9471db894872257f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb7bb73a0902071559w70b3367el9471db894872257f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Feb 7, 2009 at 3:47 PM, Éric Piel <eric.piel@tremplin-utc.net> wrote:
> > Giuseppe Bilotta schreef:
> >> Add support for HP Pavlion dv5 models, whose sensor has an inverted x
> >> axis.
> >>
> >> Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
> > Acked-by: Eric Piel <Eric.Piel@tremplin-utc.net>
> >
> > Looks good.
> > Andrew, would you mind queuing it?
> >> ---
> >> My HP Pavilion dv5 has an inverted x axis of the accelerometer, so this
> >> patch marks the inversion for all the dv5. I can include the full
> >> dmidecode output if this is deemed necessary.
> >>
> >> With the laptop standing still on my desk jstest reports X and Y values
> >> fluctuating from -8k to +8k (more or less). I assume this is normal?
> > What does "k" stands for? If that's the unit of the joystick output:
> > yes, that's perfectly normal, just some noise/vibration. If that's 1000,
> > it's far too much to be normal.
> 
> k is for thousands. I thought it could have been normal because
> someone (Pavel?) mentioned the disk park script trigged even if he was
> just walking around, so I just assumed the sensor to be extremely

I believe that it is designed to trigger at walking.

> sensible. OTOH the maximum range of the sensor, as reported by jstest,
> seems to be -32k to +32k, and 8k is about one forth of it. Considering
> sometimes the fluctuations even peak to 12k, there might be something
> else at play here. Any suggestions on helping debug the issue are
> welcome.

Ok, at my machine it fluctuates around 1K when sitting on the desk,
and maximum range is about 13-15K. So your values seem little too noisy.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
