Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbYFEGaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbYFEGaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 02:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYFEGaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 02:30:05 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:29154 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbYFEGaC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 02:30:02 -0400
Date: Thu, 5 Jun 2008 08:29:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: =?ISO-8859-1?B?yXJpYw==?= Piel <Eric.Piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@osdl.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Yan Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2.6.25.4] hwmon: HP Mobile Data Protection  System 3D 
 ACPI driver -- please review!
Message-ID: <20080605082950.6957f1a2@hyperion.delvare>
In-Reply-To: <484728B2.1000209@tremplin-utc.net>
References: <1212235533.3815.5.camel@localhost>
	<4846EBF5.2030406@tremplin-utc.net>
	<20080604225830.1dff64fc@hyperion.delvare>
	<20080604230510.GB30475@elf.ucw.cz>
	<484728B2.1000209@tremplin-utc.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2008 01:43:46 +0200, Éric Piel wrote:
> 05-06-08 01:05, Pavel Machek wrote/a écrit:
> >> So my advice is that you don't wait for a review from the hwmon people,
> >> because apparently we don't have much interest in this type of device,
> >> so you'll be waiting forever. You're much better adding the mdps driver
> >> to drivers/misc through Andrew Morton, at least until someone takes
> >> care of creating a subsystem for this type of devices and move all
> >> existing drivers there.
> > 
> > Just create drivers/accel ... accelerometers are quite common these
> > days. Going to drivers/misc is okay, too, I guess -- moves are easy
> > with git ;-).
>
> Yes, why not do one little step to the correct direction now and create
> drivers/accel, it will likely be the chosen name anyway! That will not
> yet be a "real" subsystem, just a place to put all the related drivers
> already present together.

Well, I would expect all these accelerometer drivers to have a common,
standardized interface, so this should most probably become a real
subsystem in the long run.

> Anyone against this idea?

I am in favor of it.

-- 
Jean Delvare
