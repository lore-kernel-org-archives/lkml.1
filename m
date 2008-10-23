Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYJWILo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYJWILo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYJWILY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:11:24 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:2616 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbYJWILV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:11:21 -0400
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <490031A4.9020509@tremplin-utc.net>
Date: Thu, 23 Oct 2008 10:11:16 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080929 Mandriva/2.0.0.17-2mdv2009.0 (2009.0) Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Yan Burman <burman.yan@gmail.com>,
       Pau Oliva Fora <pau@eslack.org>,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver (take 4)
References: <48FA3368.1040605@tremplin-utc.net> <20081022152013.GB25548@elf.ucw.cz> <alpine.LFD.1.10.0810221446100.3010@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0810221446100.3010@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown schreef:
>> +static struct acpi_device_id lis3lv02d_device_ids[] = {
>> +       {"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
> 
> Has HP provided any documentation or engineering support
> to help support this work?
Not to my knowledge. Ironically, one of the laptops supported, the HP
2133, is even sold with Linux pre-installed!

> 
> Note that other laptop drivers that utilize vendor-specific
> ACPI hooks tend to live under drivers/misc -- for lack
> of a better home.
Yes, this could be also a place for the driver, but as all the other
accelerometer drivers are currently in hwmon, it was decided to put it
there as well. The plan is to move them to their own subsystem once a
accelerometer subsystem is agreed on (Jonathan Cameron is working on
this, with industrialio).

See you,
Eric

