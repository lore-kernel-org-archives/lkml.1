Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbZKCTRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbZKCTRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbZKCTRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:17:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58639 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbZKCTRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:17:41 -0500
Date: Tue, 3 Nov 2009 20:17:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32-rc5: unexpected thermal shutdown?
Message-ID: <20091103191734.GD3312@elf.ucw.cz>
References: <20091103105717.GA2516@elf.ucw.cz>
 <200911031825.04169.elendil@planet.nl>
 <20091103183739.GA3312@elf.ucw.cz>
 <200911032012.53556.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911032012.53556.elendil@planet.nl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-11-03 20:12:52, Frans Pop wrote:
> On Tuesday 03 November 2009, you wrote:
> > pavel@amd:~$ grep . /proc/acpi/thermal_zone/*/*
> > /proc/acpi/thermal_zone/THM0/cooling_mode:<setting not supported>
> > /proc/acpi/thermal_zone/THM0/polling_frequency:<polling disabled>
> > /proc/acpi/thermal_zone/THM0/state:state:                   ok
> > /proc/acpi/thermal_zone/THM0/temperature:temperature:           58 C
> > /proc/acpi/thermal_zone/THM0/trip_points:critical (S5):         127 C
> 
> Right, so this zone does not have a passive trip point. If it reaches 
> critical temp before THM1, it would cause exactly what you saw.
> 
> Try recreating the same situation while watching the temp for both thermal 
> zones.

Well, I'll try _not_ to recreate this situation :-). If it starts
happening too often, I'll play with passive limits. But... thanks!

> > 128C means "slightly fake" temperature sensor. It seems that it just
> > produces 128 in THM0 when temperature exceeds some other limit.
> 
> Hmm. If THM0 does not have *any* other values between 58 and 128 then the 
> above will probably not work. If it makes a few jumps, you should
> adjust

It has some values between 58 and 128, but I'm not sure how many.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
