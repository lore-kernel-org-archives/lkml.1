Return-Path: <linux-kernel-owner+w=401wt.eu-S966195AbXG3Cup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966195AbXG3Cup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 22:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966536AbXG3CtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 22:49:06 -0400
Received: from smtpout.mac.com ([17.250.248.172]:62889 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965998AbXG3CtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 22:49:03 -0400
In-Reply-To: <1185744640.2295.4.camel@work>
References: <200707251238.50218.lenb@kernel.org> <200707292317.21419.rjw@sisk.pl> <20070729211824.GL16817@stusta.de> <200707292336.55588.rjw@sisk.pl> <1185744640.2295.4.camel@work>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <094CE21F-9AB6-4DD5-AF89-3A72116887E6@mac.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH 2/2] Introduce CONFIG_SUSPEND
Date: Sun, 29 Jul 2007 22:47:57 -0400
To: Richard Hughes <hughsient@gmail.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 29, 2007, at 17:30:40, Richard Hughes wrote:
> So are you guys using:
>
> "standby" = idle state, ~0.5 seconds
> "suspend" = sleep to ram, ~10 seconds
> "hibernate" = sleep to disk, ~30 seconds
>
> If so - you rock. This is the common nomenclature I've been pushing  
> for
> a few months now in GNOME, KDE and general userspace. I've written  
> up a
> spec here:
> http://cvs.gnome.org/viewcvs/*checkout*/gnome-power-manager/docs/ 
> sleep-names.html

Well, those times don't quite work for my PowerBook.  If we fixed  
suspend-to-RAM to reinitialize devices in parallel then it would  
easily hit 0.5 second transition times, but even now it's only at  
most 2 seconds.  Also once in a while I'll be too hasty plugging my  
USB devices and manage to hardlock one of the USB busses, but that's  
an isolated USB driver suspend issue.

And it's certainly not called "standby", because the box can  
literally remain asleep for 7 days on a full charge, versus about 5  
hours when just idle with wireless, backlight, and HDD off.

Cheers,
Kyle Moffett
