Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZK3RwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZK3RwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZK3RwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:52:19 -0500
Received: from bamako.nerim.net ([62.4.17.28]:59802 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbZK3RwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:52:18 -0500
Date: Mon, 30 Nov 2009 18:52:21 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-omap@vger.kernel.org, Mikko Ylinen <mikko.k.ylinen@nokia.com>
Subject: Re: [PATCH] mfd: twl4030: Driver for twl4030 madc module
Message-ID: <20091130185221.1215213f@hyperion.delvare>
In-Reply-To: <37786d4b0911300558i984d2bdj9b0c5617503c1950@mail.gmail.com>
References: <1259146071-2372-1-git-send-email-amit.kucheria@verdurent.com>
	<20091127193636.GA16866@sortiz.org>
	<37786d4b0911300558i984d2bdj9b0c5617503c1950@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 15:58:39 +0200, Amit Kucheria wrote:
> On Fri, Nov 27, 2009 at 9:36 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > By the way, have you considered moving this one to drivers/hwmon ?
> 
> I haven't. I moved it from i2c/chips/ to the most obvious place I
> could think of - drivers/mfd. But wasn't this the point of mfd - that
> various subcomponents drivers could live there instead of being
> scattered across the driver tree?
> 
> Adding Jean to CC, if he would consider taking this driver in drivers/hwmon..

In its current form, no. This driver doesn't implement the sysfs
interface described in Documentation/hwmon/sysfs-interface. It doesn't
even register a hwmon class device. So it doesn't belong in
drivers/hwmon.

-- 
Jean Delvare
