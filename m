Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab0CAJts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:49:48 -0500
Received: from lucidpixels.com ([75.144.35.66]:39713 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab0CAJtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:49:47 -0500
Date: Mon, 1 Mar 2010 04:49:46 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: 2.6.33: Intel DP55KG - USB still not fixed: USBDEVFS_CONTROL failed
 cmd usbhid-ups rqt 161 rq 1 len 4 ret -110
Message-ID: <alpine.DEB.2.00.1003010446390.20072@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Feb 28 19:39:10 p34 kernel: [274199.684428] usb 2-1.7: usbfs: USBDEVFS_CONTROL
failed cmd usbhid-ups rqt 161 rq 1 len 4 ret -110

I know the DP55KG has USB problems (still, apparently) but was curious 
what the (above) error means?

In addition, this occurs when the CPU is maxed out, this still occurs
(many interrupts/from a backup etc), someone at Intel needs to run
nut with a UPS and then run some heavy CPU-bound processes and they will
see the same problem.

Feb 28 22:08:44 p34 upsd[13131]: Data for UPS [apc] is stale - check driver
Feb 28 22:08:48 p34 upsd[13131]: UPS [apc] data is no longer stale
Feb 28 22:58:43 p34 upsd[13131]: Data for UPS [apc] is stale - check driver
Feb 28 22:58:45 p34 upsd[13131]: UPS [apc] data is no longer stale

Justin.


