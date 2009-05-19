Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZESG1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZESG1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZESG1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:27:37 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:60166 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZESG1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:27:36 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Marcel Holtmann <marcel@holtmann.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on suspend
Date: Tue, 19 May 2009 08:27:52 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Mario Limonciello <mario_limonciello@dell.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4A11C126.1000704@dell.com> <20090519050327.GA22637@srcf.ucam.org> <1242710064.3147.4.camel@localhost.localdomain>
In-Reply-To: <1242710064.3147.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905190827.52541.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. Mai 2009 07:14:24 schrieb Marcel Holtmann:
> > > When coming out of S3 if the killswitch isn't activated, the logical
> > > USB mouse isn't coldplugged again preventing the udev rule from being
> > > matched upon.  You can manually run hid2hci and the device will switch
> > > modes.
> >
> > Ok. I don't think the right way to implement this is forcing dell-laptop
> > to simulate an unplug. The HCI driver should be responsible for saving
> > and restoring state of the device in its suspend/resume method.
>
> what do you expect the generic USB driver to do? I don't see anything we
> can do about it, if the device gets removed from underneath us.

In order to do this we'd have to put hid2hci into usbcore and maintain
a list of devices it should operate on.

	Regards
		Oliver

