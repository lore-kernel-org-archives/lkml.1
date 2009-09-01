Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbZIAG2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbZIAG2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 02:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZIAG2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 02:28:53 -0400
Received: from mail-px0-f204.google.com ([209.85.216.204]:45653 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZIAG2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 02:28:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=SX3FbciSqzQldEfmxgpxAmxkyrekQLCGw4erIqVLWe0BPDFmft3A3S8YSdPVW03FSD
         3BTRoIstCDDdLNSPfdJ3sXk+E6wxagkdVU6bDNAX5wIWsBpcNPG2zKxXjOKvEg7JfCH7
         ZZsp6ZRoZww5Jm05U46MW3H2c4vUvDHOJkpr0=
Date: Mon, 31 Aug 2009 23:28:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH V5 0/2] Ambient Light Sensor support
References: <1251706025.3483.159.camel@rzhang-dt> <alpine.LFD.2.00.0908311303340.19451@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0908311303340.19451@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090901070129.F402D526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 01:04:35PM -0400, Len Brown wrote:
> I put this in the acpi test tree, with the expectation
> that it will have at least one minor revision update
> before going upstream.
> 
> thanks,
> Len Brown, Intel Open Source Technology Center
> 

Breaks build here...

-- 
Dmitry

ACPI: als - fix compile errors

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

PREFIX was undefined causing compiler to barf.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/acpi/als.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/acpi/als.c b/drivers/acpi/als.c
index 6743ba7..51583a8 100644
--- a/drivers/acpi/als.c
+++ b/drivers/acpi/als.c
@@ -30,6 +30,8 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
+#define PREFIX "ACPI: "
+
 #define ACPI_ALS_CLASS			"als"
 #define ACPI_ALS_DEVICE_NAME		"Ambient Light Sensor"
 #define ACPI_ALS_NOTIFY_ILLUMINANCE	0x80
