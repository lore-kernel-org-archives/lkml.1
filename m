Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbYAVFuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbYAVFuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 00:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYAVFun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 00:50:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:38976 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYAVFum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 00:50:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EoTWnToPSKoU/HmHORYDiP7q9niWMhjIRCcdzuUp9peKr6fem9hT9P3ZTxf6mvrkUPv9MWXfPalsgjzTIFBpdDzCWAlsDAviyvGPtKhr3hQTkUzHsIppJLtCcLDPg4aUjPOtq1Qf2xmFRZOujPQvbUoSK4wdU9QjR/sCk2ulE0Q=
Date: Tue, 22 Jan 2008 13:52:04 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: stefanr@s5r6.in-berlin.de, James.Bottomley@hansenpartnership.com,
       a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       stern@rowland.harvard.edu, dwmw2@infradead.org, davem@davemloft.net,
       jarkao2@gmail.com
Subject: [PATCHSET] driver core : add class iteration api
Message-ID: <20080122055204.GA3066@darkstar.te-china.tietoenator.com>
References: <20080112094233.GA2879@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112094233.GA2879@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Repost for review.

[PATCH 1/6] Add some class iteration functions in driver core
[PATCH 2-6/6] Make the drivers with class iterating to use class iteration api

toc:
---
1-driver-core-add-class-iteration-api.patch
2-ieee1394-use-class-iteration-api.patch
3-power_supply-use-class-iteration-api.patch
4-rtc-use-class-iteration-api.patch
5-scsi-use-class-iteration-api.patch
6-spi-use-class-iteration-api.patch

Summary diffstat:
---
 drivers/base/class.c              |  159 +++++++++++++++++++
 drivers/ieee1394/nodemgr.c        |  312 +++++++++++++++++++++-----------------
 drivers/power/apm_power.c         |  116 ++++++++------
 drivers/power/power_supply_core.c |   72 ++++----
 drivers/rtc/interface.c           |   22 +-
 drivers/scsi/hosts.c              |   24 +-
 drivers/spi/spi.c                 |   24 +-
 include/linux/device.h            |   11 +
 8 files changed, 488 insertions(+), 252 deletions(-)

Regards
dave
