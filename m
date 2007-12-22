Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbXLVIWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbXLVIWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 03:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbXLVIWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 03:22:00 -0500
Received: from ironport1.lbl.gov ([128.3.41.47]:30892 "EHLO ironport1.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbXLVIV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 03:21:59 -0500
X-Ironport-SBRS: 3.5
X-Brightmail-Tracker: AAAAAA==
X-BrightmailFiltered: true
X-IronPort-AV: E=Sophos;i="4.24,198,1196668800"; 
   d="scan'208";a="77590026"
Date: Sat, 22 Dec 2007 00:21:57 -0800 (PST)
From: Andrei Gaponenko <andrei.gaponenko@cern.ch>
X-X-Sender: andr@roof
To: Zhang Rui <rui.zhang@intel.com>
cc: linux-kernel@vger.kernel.org, corentincj@iksaif.net,
       sziwan@users.sourceforge.net
Subject: Re: video breaks asus-laptop display switching
In-Reply-To: <1198309997.9550.2.camel@acpi-sony>
Message-ID: <Pine.LNX.4.64.0712220013030.31611@roof>
References: <Pine.LNX.4.64.0712211433030.3239@0-11-d8-ea-8d-5b.dhcp.lbl.gov>
 <1198309997.9550.2.camel@acpi-sony>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 22 Dec 2007, Zhang Rui wrote:

> On Sat, 2007-12-22 at 06:36 +0800, Andrei Gaponenko wrote:
>>
>> With 2.6.23 or newer (including 2.6.24-rc6) kernels, writing to the
>> /sys/devices/platform/asus-laptop/display file does not do anything:
>> ...
>>
> hmm, please "echo 1 > /proc/acpi/video/xxx/DOS" in 2.6.23 and see
> if there is any difference.

ls /proc/acpi/video/
shows two identically named directories "VGA" - is this normal??

Anyway,

# cat VGA/DOS
DOS setting: <1>

# echo 3 > VGA/DOS
# cat VGA/DOS
DOS setting: <3>

but no image on external.  Now

# rmmod video
# echo 3 > /sys/devices/platform/asus-laptop/display

Got image on external

# modprobe video
# cat VGA/DOS
DOS setting: <0>

I can write 1 or 3 to DOS and read it back, but it has no effect (image on 
external turned on while video module was removed does not go away).

Please Cc: me on replies - forgot to mention this in the initial posting.

Thanks!
Andrei
