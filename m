Return-Path: <linux-kernel-owner+w=401wt.eu-S933722AbZLJKkC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722AbZLJKkC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 05:40:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933702AbZLJKj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 05:39:59 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34123 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933652AbZLJKj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 05:39:58 -0500
Date: Thu, 10 Dec 2009 11:14:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Ike Panhc <ike.pan@canonical.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Alexandre Rostovtsev <tetromino@gmail.com>
Subject: Re: [PATCH] asus-laptop: add Lenovo SL LenovoCare LED support
Message-ID: <20091210101423.GF2446@ucw.cz>
References: <1260257169-7227-1-git-send-email-ike.pan@canonical.com> <20091210100935.GB2446@ucw.cz> <71cd59b00912100238l7fe78abcrd07328c15b65971d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71cd59b00912100238l7fe78abcrd07328c15b65971d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-12-10 11:38:00, Corentin Chary wrote:
> On Thu, Dec 10, 2009 at 11:09 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > On Tue 2009-12-08 15:26:09, Ike Panhc wrote:
> >> From: Ike Panhc <ikepanhc@canonical.com>
> >>
> >> This patch is to enable the LenovoCare LED support on Lenovo SL laptop. Based
> >> on the found of the control interface by Alexandre Rostovtsev
> >>
> >> Turn on the LenovoCare LED:
> >>  (As root privileges) echo 1 > /sys/class/leds/asus\:\:LenovoCare/brightness
> >> Trun off the LenovoCare LED:
> >>  (As root privileges) echo 0 > /sys/class/leds/asus\:\:LenovoCare/brightness
> >>
> >> The patch against current checkout of acpi4asus is below.
> >
> > Is the driver severely misnamed by now? I believe Lenovo and ASUS are
> > pretty different firms...
> >
> 
> Lenovo ship DSDT with similar ATKD interace.
> See http://git.iksaif.net/?p=acpi4asus.git;a=commitdiff;h=31a38147625c283b58137db45e7507cd1e49aa05
> 

So what? Rename the driver... having Asus::lenovocare led is just wrong.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
