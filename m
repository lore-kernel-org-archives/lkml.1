Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab0CAPiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:38:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38790 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750947Ab0CAPiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:38:52 -0500
Date: Mon, 1 Mar 2010 10:38:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: 2.6.33: Intel DP55KG - USB still not fixed: USBDEVFS_CONTROL
 failed cmd usbhid-ups rqt 161 rq 1 len 4 ret -110
In-Reply-To: <alpine.DEB.2.00.1003010446390.20072@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.1003011036420.1645-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Mar 2010, Justin Piszcz wrote:

> Hi,
> 
> Feb 28 19:39:10 p34 kernel: [274199.684428] usb 2-1.7: usbfs: USBDEVFS_CONTROL
> failed cmd usbhid-ups rqt 161 rq 1 len 4 ret -110
> 
> I know the DP55KG has USB problems (still, apparently) but was curious 
> what the (above) error means?

It means that the usbhid-ups program submitted a USB control transfer
request via usbfs, and the device did not reply within the specified
timeout period.

Alan Stern

