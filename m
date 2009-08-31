Return-Path: <linux-kernel-owner+w=401wt.eu-S1751841AbZHaIJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbZHaIJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZHaIJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:09:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:42707 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbZHaIJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:09:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,304,1249282800"; 
   d="scan'208";a="546285786"
Subject: [PATCH V5 0/2] Ambient Light Sensor support
From: Zhang Rui <rui.zhang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Pavel Machek <pavel@ucw.cz>,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain
Date: Mon, 31 Aug 2009 16:07:05 +0800
Message-Id: <1251706025.3483.159.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

this is the patch set I made for the  Ambient Light Sensor device
support in linux kernel.

There are only several trivial changes compared with patch set v4,
and they are made based on the feedback from Len.
1. update the MAINTAINERS file
2. remove the .resume method in ACPI ALS driver.
   ACPI ALS driver doesn't use a cached value storing the current
   Ambient Light illuminace, thus we don't need to re-evaluate the
   _ALI method (to get the current illuminance) on resume.
3. fix a wrong comment in ACPI ALS driver.

Any comments are welcome.

thanks,
rui

