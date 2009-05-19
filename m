Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbZESGpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbZESGpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZESGp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:45:27 -0400
Received: from senator.holtmann.net ([87.106.208.187]:41555 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbZESGp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:45:26 -0400
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on
 suspend
From: Marcel Holtmann <marcel@holtmann.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       Mario Limonciello <mario_limonciello@dell.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200905190827.52541.oliver@neukum.org>
References: <4A11C126.1000704@dell.com>
	 <20090519050327.GA22637@srcf.ucam.org>
	 <1242710064.3147.4.camel@localhost.localdomain>
	 <200905190827.52541.oliver@neukum.org>
Content-Type: text/plain
Date: Mon, 18 May 2009 23:45:12 -0700
Message-Id: <1242715512.3147.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

> > > > When coming out of S3 if the killswitch isn't activated, the logical
> > > > USB mouse isn't coldplugged again preventing the udev rule from being
> > > > matched upon.  You can manually run hid2hci and the device will switch
> > > > modes.
> > >
> > > Ok. I don't think the right way to implement this is forcing dell-laptop
> > > to simulate an unplug. The HCI driver should be responsible for saving
> > > and restoring state of the device in its suspend/resume method.
> >
> > what do you expect the generic USB driver to do? I don't see anything we
> > can do about it, if the device gets removed from underneath us.
> 
> In order to do this we'd have to put hid2hci into usbcore and maintain
> a list of devices it should operate on.

you know that hid2hci is a user space utility.

Regards

Marcel


