Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbZCWKEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbZCWKEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbZCWKEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:04:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35041 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbZCWKEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:04:24 -0400
Date: Mon, 23 Mar 2009 11:07:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Mack <daniel@caiaq.de>, Eric Piel <eric.piel@tremplin-utc.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Vladimir Botka <vbotka@suse.cz>, mmarek@suse.cz
Subject: Re: hp_accel: add two more axis information
Message-ID: <20090323100659.GA17681@elf.ucw.cz>
References: <20090308202817.GA27465@elf.ucw.cz> <20090308210625.GC13309@buzzloop.caiaq.de> <20090308210757.GA17680@elf.ucw.cz> <20090322171128.26c790bb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090322171128.26c790bb.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-03-22 17:11:28, Andrew Morton wrote:
> On Sun, 8 Mar 2009 22:07:57 +0100 Pavel Machek <pavel@ucw.cz> wrote:
> 
> > On Sun 2009-03-08 22:06:25, Daniel Mack wrote:
> > > On Sun, Mar 08, 2009 at 10:03:30PM +0100, Pavel Machek wrote:
> > > > Add two more laptops to whitelist.
> > > > 
> > > > Signed-off-by: Michal Marek <mmarek@suse.cz>
> > > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > > 
> > > > 
> > > > diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
> > > > index 29c83b5..448a462 100644
> > > > --- a/drivers/hwmon/hp_accel.c
> > > > +++ b/drivers/hwmon/hp_accel.c
> > > > @@ -187,6 +187,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
> > > >  	AXIS_DMI_MATCH("NC2510", "HP Compaq 2510", y_inverted),
> > > >  	AXIS_DMI_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
> > > >  	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
> > > > +	AXIS_DMI_MATCH("HP2140", "HP 2140", xy_swap_inverted),
> > > >  	AXIS_DMI_MATCH("NC653x", "HP Compaq 653", xy_rotated_left_usd),
> > > >  	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
> > > >  	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
> > > > @@ -201,6 +202,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
> > > >  			PRODUCT_NAME, "HP Pavilion dv5",
> > > >  			BOARD_NAME, "3600",
> > > >  			y_inverted),
> > > > +	AXIS_DMI_MATCH("DV7", "HP Pavilion dv7", x_inverted),
> > > >  	{ NULL, }
> > > >  /* Laptop models without axis info (yet):
> > > >   * "NC6910" "HP Compaq 6910"
> > > 
> > > Does this apply on top of my recent ACPI resolve patches? Could you test
> > > the latest versions already?
> > 
> > I guess it should; you did not change anything in the
> > whitelist. Unfortunately, I no longer have hardware to do testing.
> 
> I'm all confused and don't know what to do with this patch.
> 
> I guess I'll just apply it and see if I get shouted at.

That sounds like a plan :-). And I don't think you'll get shouted at,
the patch should be very safe.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
