Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbZDYIUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbZDYIUg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 04:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZDYIUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 04:20:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50508 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZDYIUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 04:20:19 -0400
Date: Sat, 25 Apr 2009 10:19:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mike Rapoport <mike@compulab.co.il>
Cc: James Kosin <jkosin@beta.intcomgrp.com>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [RFD] voltage/current regulator consumer interface
Message-ID: <20090425081933.GE2428@ucw.cz>
References: <ct38K-3Fq-11@gated-at.bofh.it> <49EC9709.8070002@support.intcomgrp.com> <49ED628A.4000505@compulab.co.il> <49EDC935.7080308@beta.intcomgrp.com> <49EDD2A7.9090300@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EDD2A7.9090300@compulab.co.il>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > Then the GPS drivers should be made aware and let the drivers handle the
> > on/off interface.  If a user is allowed to turn interfaces on/off at
> > will with this then drivers could suffer from (shock)...  ie: you could
> > turn off your hard-drive in a middle of a write by the driver corrupting
> > data, if handled in the driver it could finish the write before turning
> > off the drive.  I know this is a far stretch from a GPS were the device
> > is only READ only.
> 
> The point is there's no GPS driver... GPS transceivers are usually connected to
> a serial line and the applications access the GPS data through ttySX. The case
> when there is a kernel driver for device connected to a regulator is completely
> different. It is then the driver responsibility to decide when to power on/off
> the device.

Well, then you should teach serial driver to power the (GPS) device up on
open() and power it off on close()...

Giving it better name then ttyS2 would help, too. ttyGPS?

IOW write a trivial driver even through  you could get away w/o that...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
