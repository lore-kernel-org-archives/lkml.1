Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbZKVTAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbZKVTAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 14:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZKVTAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 14:00:23 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49960 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbZKVTAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 14:00:23 -0500
Date: Sun, 22 Nov 2009 21:00:16 +0200
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: IIO: Add tsl2560-2 support to tsl2563 driver
 + 	drop tsl2561, driver.
Message-ID: <20091122190016.GE16444@smtp.gmail.com>
Mail-Followup-To: Jonathan Cameron <jic23@cam.ac.uk>,
	LKML <linux-kernel@vger.kernel.org>
References: <4B06EA3B.10500@cam.ac.uk>
 <37786d4b0911201214g65ea0f8fke1ac29b326fffe47@mail.gmail.com>
 <4B095CA4.9080406@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B095CA4.9080406@cam.ac.uk>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09 Nov 22, Jonathan Cameron wrote:
> Amit Kucheria wrote:
> > On Fri, Nov 20, 2009 at 9:12 PM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> >> These parts (tsl2560-tsl2563) are identical in interface.
> >> The tsl2563 driver is more advanced so makes sense to drop
> >> the tsl2561 driver.
> >>
> >> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> >> ---
> >> Greg, I've done the changes and driver removal as a single patch.
> >> Can separate into two if you would prefer?
> >>
> >> Amit, as promised I have tested against the tsl2561 on an imote2
> >> sensor board (for which the original driver was written). All seems
> >> to work as intended.  Only changes are addition of devices to the
> >> device table and Kconfig comment changes to reflect new support.
> >> Hope you don't mind, but I dropped the N900 reference.  These things
> >> are pretty common (including the new parts) and we don't really
> >> want to encourage people to start listing where they found. I
> >> haven't done any of the other changes I suggested, but can do
> >> those as a follow up patch if you don't mind?
> >>
> >> There are a few more similar chips with slightly different conversion
> >> functions.
> >>
> >> Thanks,
> >>
> >> Jonathan
> > 
> > Jonathan,
> > 
> > Changes looks good. I'll send my acks on the split up patches.
> Cool, I'll do them in a few mins.
> > 
> > I'm working on moving this driver to the input subsystem as agreed.
> Input?  Ambient Light sensors subsystem makes sense. Input certainly 
> does not (and will get copious NAKs). I was beginning to doubt that ALS
> will get sorted out in time for the next merge window (or that the
> various drivers would get moved across in time), hence this patch to
> clear up a bit of a mess and a lot of pointless code in IIO as Greg has
> already taken your driver into the staging tree.

Err.. sorry, distracted reply. I meant the ALS subsystem that Rui is sheparding. 

> > I
> > was planning to address your review comments in that rework. I can
> > defer that work if you want.
> Sure, that's fine with me, though given the wonders of staging, you may
> well find a 3rd party submits patches for your driver in the meantime ;)
> 

Less work for me :)


-- 
------------------------------------------------------------
Amit Kucheria, Finland
------------------------------------------------------------
