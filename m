Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbYCZPWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbYCZPWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYCZPWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:22:39 -0400
Received: from mga06.intel.com ([134.134.136.21]:57303 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753017AbYCZPWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:22:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,559,1199692800"; 
   d="scan'208";a="265115940"
Date: Wed, 26 Mar 2008 08:25:59 -0700
From: mark gross <mgross@linux.intel.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Real time USB2Serial devices and behaivor
Message-ID: <20080326152559.GA17164@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 26 Mar 2008 15:20:13.0822 (UTC) FILETIME=[E39421E0:01C88F54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At home I'm playing with a real time amateur robotics application with a
micro controller talking over its serial port to a Linux box running an RT
kernel and some RT user mode software to suck in the serial port data
and do some processing in real time.  One example of what I want to do
with this type of configuration is to create a type of IMU thing and run
the data through a kalman filter to see how good I can do with my
hardware.

I'll be sending data regularly at data rates between 50 and 500 HZ from
the MCU (depending on mode)

Anyway, I have the RT code and the system prototyped using the hardware
serial port on my desktop and I'm getting rock solid RT delivery times
of the data +/- 30usec.  While stressing the system in CPU and disk. (I
still need to do the test while flood pinging the box)  However; when I
use my USB dongle instead of the hardware serial port the system falls
over WRT real time behavior.

I'm just starting to look into the behavior now but has anyone looked at
the RT'ness of USB2Serial + USB stack yet?  I would like to see what
other folks have done.  My googleing last night didn't get any useful
hits.

BTW Why does the PL2303 have a 1KB buffer for incoming data?

I'm a bit green at RT work at this level.  What are the best ways for
drilling down to figure out what the problems are so I can make a patch?

Thanks for any advice or pointers.  

--mgross
