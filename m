Return-Path: <linux-kernel-owner+w=401wt.eu-S1762095AbYFEU7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762095AbYFEU7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbYFEU7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:59:22 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43815 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYFEU7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:59:21 -0400
Date: Thu, 5 Jun 2008 10:19:18 +0200
From: Pavel Machek <pavel@suse.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: =?iso-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>,
       Andrew Morton <akpm@osdl.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Yan Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2.6.25.4]  hwmon: HP Mobile Data Protection System 3D
	ACPI driver -- please review!
Message-ID: <20080605081918.GA31075@elf.ucw.cz>
References: <1212235533.3815.5.camel@localhost> <4846EBF5.2030406@tremplin-utc.net> <20080604230326.GA30475@elf.ucw.cz> <20080605010647.GC16599@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605010647.GC16599@khazad-dum.debian.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-06-04 22:06:47, Henrique de Moraes Holschuh wrote:
> On Thu, 05 Jun 2008, Pavel Machek wrote:
> > > > 3) Makes it possible to power the device off.
> > 
> > But this part is what I don't understand. powering off does not seem
> > to belong there. Why can't you just use acpi to power down?
> 
> I think he means power down the g-sensors and related filters and A/D
> circuitry.  The out-of-tree version of the HDAPS driver can do it as
> well.

Yes, I misunderstood.

> For what is it worth, I think drivers/accel is a good idea, and I think
> the other accel drivers should be moved there.

Agreed.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
