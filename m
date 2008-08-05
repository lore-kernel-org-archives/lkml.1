Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYHEO5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYHEO5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbYHEOu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:50:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:49974 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbYHEOu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:50:28 -0400
Message-ID: <48986797.5090007@netcom.eu>
Date: Tue, 05 Aug 2008 16:45:43 +0200
From: David Engraf <david.engraf@netcom.eu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Dasgupta, Romit" <romit@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg KH <greg@kroah.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] [PM] Fixes missing PM entries in sysfs without CONFIG_PM_SLEEP
References: <Pine.LNX.4.44L0.0808051020220.2518-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808051020220.2518-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19IzPQyaG0sxNnuDdKtFyZBfmMem5qX2p0uIhM
 hr4vSTuQZf69smz2XfnK9zd+ssw+nIZ+mVFW8oXNxW4dIxqryk
 Z8PVwCVZXZPsbbbM6navw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there an option to make a patch for the recent 2.6.26.1 kernel, so
that I can use the next 2.6.26.2 kernel instead of waiting a few months
for the next big release?

Thanks David Engraf


Alan Stern wrote:
> On Tue, 5 Aug 2008, Dasgupta, Romit wrote:
>
>   
>> A minor change below: Removed old goto label PMError and introduced SysFSError.
>> Tested with CONFIG_PM, CONFIG_PM_SLEEP, without CONFIG_PM and ofcourse with CONFIG_USB_SUSPEND. Works fine.
>>     
>
> Strictly speaking, I suppose the statement label should be 
> DPMSysfsError.
>
> On the other hand, the corresponding label for
> device_add_class_symlinks() is SymlinkError, not
> DeviceAddClassSymlinksError.  The label for device_add_attrs() is
> AttrsError, not DeviceAddAttrsError.  And the label for
> bus_add_device() is BusError, not BusAddDeviceError.
>
> Following those precedents, it seems appropriate that the label for
> dpm_sysfs_add() should be DPMError.  I'll make the change and submit
> the patch.
>
> Alan Stern
>
>   
