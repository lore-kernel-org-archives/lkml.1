Return-Path: <linux-kernel-owner+w=401wt.eu-S1762916AbYFDXE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916AbYFDXE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758277AbYFDXES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:04:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37022 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbYFDXES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:04:18 -0400
Date: Thu, 5 Jun 2008 01:05:10 +0200
From: Pavel Machek <pavel@suse.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: =?iso-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>,
       Andrew Morton <akpm@osdl.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Yan Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2.6.25.4] hwmon: HP Mobile Data Protection  System 3D
	ACPI driver -- please review!
Message-ID: <20080604230510.GB30475@elf.ucw.cz>
References: <1212235533.3815.5.camel@localhost> <4846EBF5.2030406@tremplin-utc.net> <20080604225830.1dff64fc@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604225830.1dff64fc@hyperion.delvare>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> So my advice is that you don't wait for a review from the hwmon people,
> because apparently we don't have much interest in this type of device,
> so you'll be waiting forever. You're much better adding the mdps driver
> to drivers/misc through Andrew Morton, at least until someone takes
> care of creating a subsystem for this type of devices and move all
> existing drivers there.

Just create drivers/accel ... accelerometers are quite common these
days. Going to drivers/misc is okay, too, I guess -- moves are easy
with git ;-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
