Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbYJWJkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbYJWJkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYJWJkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:40:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51170 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYJWJki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:40:38 -0400
Date: Thu, 23 Oct 2008 10:24:43 +0200
From: Pavel Machek <pavel@suse.cz>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Yan Burman <burman.yan@gmail.com>,
       Pau Oliva Fora <pau@eslack.org>,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver (take 4)
Message-ID: <20081023082443.GA1821@elf.ucw.cz>
References: <48FA3368.1040605@tremplin-utc.net> <20081022152013.GB25548@elf.ucw.cz> <alpine.LFD.1.10.0810221446100.3010@localhost.localdomain> <490031A4.9020509@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490031A4.9020509@tremplin-utc.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-23 10:11:16, Eric Piel wrote:
> Len Brown schreef:
> >> +static struct acpi_device_id lis3lv02d_device_ids[] = {
> >> +       {"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
> > 
> > Has HP provided any documentation or engineering support
> > to help support this work?
> Not to my knowledge. Ironically, one of the laptops supported, the HP
> 2133, is even sold with Linux pre-installed!

Actually, they did promise some docs/support to me, but Eric was just
too fast ;-). 

> > Note that other laptop drivers that utilize vendor-specific
> > ACPI hooks tend to live under drivers/misc -- for lack
> > of a better home.
> Yes, this could be also a place for the driver, but as all the other
> accelerometer drivers are currently in hwmon, it was decided to put it
> there as well. The plan is to move them to their own subsystem once a
> accelerometer subsystem is agreed on (Jonathan Cameron is working on
> this, with industrialio).

ACK. hdaps is in hwmon, too.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
