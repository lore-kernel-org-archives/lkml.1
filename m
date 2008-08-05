Return-Path: <linux-kernel-owner+w=401wt.eu-S1759107AbYHEO0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107AbYHEO0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbYHEO0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:26:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44801 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756230AbYHEO02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:26:28 -0400
Date: Tue, 5 Aug 2008 10:26:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Dasgupta, Romit" <romit@ti.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, David Engraf <david.engraf@netcom.eu>,
       Greg KH <greg@kroah.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: RE: [PATCH] [PM] Fixes missing PM entries in sysfs without
 CONFIG_PM_SLEEP
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593013C9AE7E8@dbde02.ent.ti.com>
Message-ID: <Pine.LNX.4.44L0.0808051020220.2518-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008, Dasgupta, Romit wrote:

> A minor change below: Removed old goto label PMError and introduced SysFSError.
> Tested with CONFIG_PM, CONFIG_PM_SLEEP, without CONFIG_PM and ofcourse with CONFIG_USB_SUSPEND. Works fine.

Strictly speaking, I suppose the statement label should be 
DPMSysfsError.

On the other hand, the corresponding label for
device_add_class_symlinks() is SymlinkError, not
DeviceAddClassSymlinksError.  The label for device_add_attrs() is
AttrsError, not DeviceAddAttrsError.  And the label for
bus_add_device() is BusError, not BusAddDeviceError.

Following those precedents, it seems appropriate that the label for
dpm_sysfs_add() should be DPMError.  I'll make the change and submit
the patch.

Alan Stern

