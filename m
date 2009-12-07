Return-Path: <linux-kernel-owner+w=401wt.eu-S935229AbZLGPEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935229AbZLGPEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935189AbZLGPEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:04:32 -0500
Received: from bamako.nerim.net ([62.4.17.28]:61719 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935167AbZLGPEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:04:30 -0500
Date: Mon, 7 Dec 2009 16:04:32 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>, rui.zhang@intel.com,
       jic23@cam.ac.uk, alan@linux.intel.com, linux-acpi@vger.kernel.org,
       gregkh@suse.de, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv2 0/2] Introducing the Ambient Light Sensor (ALS) class
Message-ID: <20091207160432.3108e17b@hyperion.delvare>
In-Reply-To: <37786d4b0912070650g7ba7604bv63365a21f980501d@mail.gmail.com>
References: <1259581514-15356-1-git-send-email-amit.kucheria@verdurent.com>
	<37786d4b0912070650g7ba7604bv63365a21f980501d@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009 16:50:23 +0200, Amit Kucheria wrote:
> On Mon, Nov 30, 2009 at 1:45 PM, Amit Kucheria
> <amit.kucheria@verdurent.com> wrote:
> > Introduce a new class of devices to handle ambient light sensors. Currently
> > only one sysfs inteface, 'illuminance' is introduced. More will be added as
> > drivers are ported to use this new class.
> >
> > Amit Kucheria (1):
> >  als: add unique device-ids to the als device class
> >
> > Zhang Rui (1):
> >  introduce ALS sysfs class
> >
> >  Documentation/ABI/testing/sysfs-class-als |    9 ++
> >  MAINTAINERS                               |    6 ++
> >  drivers/Kconfig                           |    2 +
> >  drivers/Makefile                          |    1 +
> >  drivers/als/Kconfig                       |   10 +++
> >  drivers/als/Makefile                      |    5 +
> >  drivers/als/als_sys.c                     |  116 +++++++++++++++++++++++++++++
> >  include/linux/als_sys.h                   |   35 +++++++++
> >  8 files changed, 184 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/ABI/testing/sysfs-class-als
> >  create mode 100644 drivers/als/Kconfig
> >  create mode 100644 drivers/als/Makefile
> >  create mode 100644 drivers/als/als_sys.c
> >  create mode 100644 include/linux/als_sys.h
> >
> 
> (Bump)
> 
> Is there any blocker to adding this for 2.6.33?

As far as I am concerned, it's ready to go. And I would love to see it
in 2.6.33.

> Which maintainer will pick up the ALS framework?

As Rui volunteered to be the maintainer of this new subsystem, it would
seem fair that he takes care of the initial push as well.

-- 
Jean Delvare
