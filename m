Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbYJ2Mbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbYJ2Mbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 08:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbYJ2Mbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 08:31:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3321 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbYJ2Mbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 08:31:35 -0400
Date: Wed, 29 Oct 2008 12:27:23 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Liam Girdwood <lrg@kernel.org>, felipe.balbi@nokia.com,
       ext Jonathan Cameron <jic23@cam.ac.uk>,
       eric miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regulator RFC] da903x: Where should usb charge pump support go?
Message-ID: <20081029122705.GA14648@sirena.org.uk>
References: <4906F500.7080100@cam.ac.uk> <20081028112341.GF27144@gandalf.research.nokia.com> <1225195382.28382.168.camel@dell-desktop.example.com> <4908547C.4090907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4908547C.4090907@gmail.com>
X-Cookie: Who messed with my anti-paranoia shot?
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 12:18:04PM +0000, Jonathan Cameron wrote:

> ADC
>     Used partly for internal monitoring functionality, partly for
>     auxiliary inputs.  The question on this is whether to implement
>     it as a hwmon driver (somewhat unusual form, but sort of fits)
>     or whether some of this is needed for feedback to the battery
>     charger code etc.

For WM8350 this is implemented as a device-specific function in the
driver core which is then used by other drivers to export the
information to relevant subsystems.

There was some work on a generic ADC framework that might be a better
fit for the auxiliary inputs but I'm not sure where that's going ATM or
if it's really appropriate.
