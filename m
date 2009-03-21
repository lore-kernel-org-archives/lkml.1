Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbZCUMFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbZCUMFP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZCUME6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:04:58 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:58360 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbZCUME5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:04:57 -0400
Date: Sat, 21 Mar 2009 13:04:50 +0100
From: Arjan Opmeer <arjan@opmeer.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20090321120450.GA24247@adopmeer.homeip.net>
References: <20090320055239.GA19800@adopmeer.homeip.net> <200903202246.31493.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903202246.31493.dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [PATCH] input: elantech.c make sure touchpad is really in
	absolute mode
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, Mar 20, 2009 at 10:46:31PM -0700, Dmitry Torokhov wrote:
> On Thursday 19 March 2009 22:52:39 Arjan Opmeer wrote:
> >
> > There exist laptops with Elantech touchpads where switching to absolute
> > mode does not happen, although writing the configuration register
> > succeeds without error. Reading back the register afterwards reveils
> > that the absolute mode bit is not set as if masked out by the touchpad
> > firmware.
> >
> > Always read back register 0x10, make sure that for hardware version 1
> > the absolute mode bit is actually set and fail otherwise. This prevents
> > the case where the touchpad is claimed by the Elantech driver but is
> > nonetheless not working.
> 
> Makes sense, will apply. Although, have you tried repeating the switch or
> maybe issuing full reset before trying again?

No. I am sorry. I had this problem reported by two different users that both
kind of lost interest when I pointed out that the driver as it stands was
not able to support their laptops. Without access to the hardware and
without users willing to test I am rather stuck.

So I thought the sensible thing left to do was to put an extra check and
warning in the driver to prevent other users from falling in that trap where
their touchpad isn't working.


Arjan
