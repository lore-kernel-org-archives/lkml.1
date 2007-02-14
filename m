Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbXBNAlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbXBNAlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932116AbXBNAlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:41:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbXBNAlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:41:01 -0500
Message-ID: <45D25ABE.5080400@redhat.com>
Date: Tue, 13 Feb 2007 19:41:34 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Dave Jones <davej@redhat.com>
Subject: Is this bug too obvious?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/usb/net/usbnet.c:

int
usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
{
        struct usbnet                   *dev;
        struct net_device               *net;
        struct usb_host_interface       *interface;
        struct driver_info              *info;
        struct usb_device               *xdev;
        int                             status;

	...

        net = alloc_etherdev(sizeof(*dev));
                                    ^^^^
	                            *net ???

