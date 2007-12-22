Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbXLVHsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbXLVHsj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 02:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbXLVHsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 02:48:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:6932 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbXLVHs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 02:48:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,198,1196668800"; 
   d="scan'208";a="250500461"
Subject: Re: video breaks asus-laptop display switching
From: Zhang Rui <rui.zhang@intel.com>
To: Andrei Gaponenko <andrei.gaponenko@cern.ch>
Cc: linux-kernel@vger.kernel.org, corentincj@iksaif.net,
       sziwan@users.sourceforge.net
In-Reply-To: <Pine.LNX.4.64.0712211433030.3239@0-11-d8-ea-8d-5b.dhcp.lbl.gov>
References: <Pine.LNX.4.64.0712211433030.3239@0-11-d8-ea-8d-5b.dhcp.lbl.gov>
Content-Type: text/plain
Date: Sat, 22 Dec 2007 15:53:17 +0800
Message-Id: <1198309997.9550.2.camel@acpi-sony>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-22 at 06:36 +0800, Andrei Gaponenko wrote:
> 
> Hi,
> 
> With 2.6.23 or newer (including 2.6.24-rc6) kernels, writing to the
> /sys/devices/platform/asus-laptop/display file does not do anything:
> 
> Cold boot to single user, then connect an external monitor
> 
> # cat  /sys/devices/platform/asus-laptop/display
> 1
> 
> OK, only the built in LCD is enabled. Try to enable
> the external monitor as well:
> 
> # echo 3 > /sys/devices/platform/asus-laptop/display
> 
> still no image on the external.
> 
> # cat  /sys/devices/platform/asus-laptop/display
> 1
> 
> Still "1", not the "3" we wrote. On the other hand if I boot with an
> external monitor attached, the "display" file always contains 3, even
> after writing 1 there, and there is image on both monitors.
> 
> In 2.6.22 I had to load asus-laptop by hand, but then display
> switching worked nicely. 
> 
> I've noticed that if I do
> 
> # rmmod video
> 
> display switching starts working again with the newer kernels.
> The "video" module was auto-loaded on my system in 2.6.22, but
> did not cause the conflict.
hmm, please "echo 1 > /proc/acpi/video/xxx/DOS" in 2.6.23 and see
if there is any difference.

Thansk,
Rui


