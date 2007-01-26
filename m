Return-Path: <linux-kernel-owner+w=401wt.eu-S1161058AbXAZRyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161058AbXAZRyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161099AbXAZRyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:54:06 -0500
Received: from lucidpixels.com ([75.144.35.66]:37526 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161058AbXAZRyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:54:05 -0500
Date: Fri, 26 Jan 2007 12:54:02 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: Kernel 2.6.19.2: Belkin UPS on Serial vs. USB
Message-ID: <Pine.LNX.4.64.0701261250470.12467@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When I disconnect my UPS from the wall, I have to wait 15-30 seconds 
before the USB drier 'polls' this information and tells me that the UPS is 
on battery power (via knutclient or syslog via nut):

ups@p34 POWER ALERT on Fri Jan 26 12:49:29 EST 2007

With a serial connection, I would get the alerts IMMEDIATELY (0.5-1 
seconds) after disconnecting the UPS.  My new machine does not have a 
serial port built-in, only a serial header, and of course does not come 
with an included cable, so I chose to use USB.

My question is, how do I change the polling time for the USB subsystem to 
match that of the serial port, or would I not want to do that for other 
reasons?

The reason I'd like to is I am not going to see any power alerts for 
unless there is a power outage for longer than 15-30 seconds.

Justin.
