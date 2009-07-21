Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZGUKiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZGUKiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbZGUKix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:38:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53746 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbZGUKiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:38:52 -0400
Date: Tue, 21 Jul 2009 12:38:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Dream in staging: separate Kconfig/Makefile into subdirectory
Message-ID: <20090721103846.GH4133@elf.ucw.cz>
References: <20090720103532.GD19341@elf.ucw.cz> <200907211416.21945.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907211416.21945.bzolnier@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-07-21 14:16:20, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi Pavel,
> 
> On Monday 20 July 2009 12:35:32 Pavel Machek wrote:
> > Separate Kconfig/Makefile glue from dream into subdirectory. I plan to
> > add few more drivers, and changing staging/Makefile each time sounds
> > like inviting conflicts.
> >     
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> While you are at it could you please limit the scope of those Kconfigs
> to Dream platform somehow (today's -next asked me about MSM_SMD and upon
> checking I'm pretty sure that I don't need it on x86-32 ;)..

Umm, yes.

---

Limit SMD communication glue to MSM platform. It is closely tied to
MSM architecture.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/dream/smd/Kconfig b/drivers/staging/dream/smd/Kconfig
index 3c1db3c..17b8bdc 100644
--- a/drivers/staging/dream/smd/Kconfig
+++ b/drivers/staging/dream/smd/Kconfig
@@ -1,4 +1,5 @@
 config MSM_SMD
+	depends on ARCH_MSM
 	default y
 	bool "MSM Shared Memory Driver (SMD)"
 	help

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
