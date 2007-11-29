Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbXK2ICV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbXK2ICV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 03:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbXK2ICM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 03:02:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450AbXK2ICL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:02:11 -0500
Date: Thu, 29 Nov 2007 00:01:49 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       linux-usb@vger.kernel.org, preining@logic.at,
       kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: Add the infamous Huawei E220 to option.c
Message-Id: <20071129000149.7569eab1.zaitcev@redhat.com>
In-Reply-To: <200711290844.39428.oliver@neukum.org>
References: <20071128161305.b01167b3.zaitcev@redhat.com>
	<20071129073303.1913505tnv2m8v0g@webmail.tugraz.at>
	<200711290844.39428.oliver@neukum.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 08:44:38 +0100, Oliver Neukum <oliver@neukum.org> wrote:

> 3. Make sure usbcore doesn't probe the devices in the wrong mode with the 
> option driver

This fixes duplication. And to take it further, why don't we turn this
idea around and let usb-storage fail to attach with some "ignore" quirk?
I suspect that someone put the initializer into usb-storage in order
to let the generic usb serial to work, but this simply was a bad idea.

-- Pete
