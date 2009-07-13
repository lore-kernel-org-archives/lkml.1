Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZGMVGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZGMVGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbZGMVGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:06:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55372 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931AbZGMVGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:06:22 -0400
Date: Mon, 13 Jul 2009 23:06:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Arve Hj??nnev??g <arve@google.com>, Iliyan Malchev <malchev@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC Dream camera support for staging
Message-ID: <20090713210613.GA13539@elf.ucw.cz>
References: <20090629114339.GA25552@elf.ucw.cz> <20090629121023.GD28046@google.com> <20090630102457.GA25802@elf.ucw.cz> <a55d774e0906300338l7743d566k5b463eed3efd1ea1@mail.gmail.com> <20090709101315.GF10937@elf.ucw.cz> <a55d774e0907090406u5e91b5c9r2303b098d0e44988@mail.gmail.com> <20090713202720.GD2569@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713202720.GD2569@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > +config TOUCHSCREEN_ELAN_I2C_8232
> > > /
> > > +config TOUCHSCREEN_SYNAPTICS_I2C_RMI
> > >
> > > ...which one is it on Dream?
> > 
> > Both, possibly.  HTC used elan as a second source, so some devices
> > will use elan, some use synaptics.
> 
> Is there easy way to tell the machines apart? 

cat /sys/class/input/*/name seems to work; I have synaptics here.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
