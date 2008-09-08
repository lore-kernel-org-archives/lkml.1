Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYIHBO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYIHBO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 21:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYIHBOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 21:14:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:39580 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbYIHBOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 21:14:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,354,1217833200"; 
   d="scan'208";a="613713987"
Subject: Re: ACPI video.c brightness handler conflicts with toshiba_acpi
From: Zhang Rui <rui.zhang@intel.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: toshiba_acpi@memebeam.org, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200809061108.34877.arvidjaar@mail.ru>
References: <200809061108.34877.arvidjaar@mail.ru>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 09:13:52 +0800
Message-Id: <1220836432.3441.25.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-06 at 11:08 +0400, Andrey Borzenkov wrote:
> I have now two different devices that refer to the same hardware:
> 
> lrwxrwxrwx 1 root root 0 2008-09-06 11:04 acpi_video0 -> ../../devices/virtual/backlight/acpi_video0/
> lrwxrwxrwx 1 root root 0 2008-09-06 11:04 toshiba -> ../../devices/virtual/backlight/toshiba/
> 
> Unfortunately, due to ACPI implementation the acpi_video0 one is much
> inferior (as it provides only effectively two levels instead of 8);
> and user level tools are apparently quite confused which one to select.
> 
> Is there any mechanism that would allow tochiba_acpi to claim brightness
> for internal LCD screen that video would not attempt to grab it too?
> 
Yes, the patches are in Andi's test tree currently.

please run
#git-clone
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-acpi-2.6
acpi_test
#git-branch -r
#git-branch --track test origin/test
#git-checkout test

to get the source code if you want to give it a try. :)

thanks,
rui

