Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYFYXiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYFYXiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYFYXiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:38:01 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:57555 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbYFYXiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:38:00 -0400
Message-ID: <4862D704.80607@keyaccess.nl>
Date: Thu, 26 Jun 2008 01:38:44 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Zhang Rui <rui.zhang@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Hans de Goede <j.w.r.degoede@hhs.nl>, Jean Delvare <khali@linux-fr.org>,
       linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.26-rc] ACPI Thermal Zone driver breaks lm-sensors
 2 userspace
References: <fa.4PGqX9CuLbgiTimfCcon+PlAMxk@ifi.uio.no> <fa.PWu620xEt5OlYdOezvRtQriuNjM@ifi.uio.no> <48605935.5070407@shaw.ca> <alpine.LFD.1.10.0806232004480.2926@woody.linux-foundation.org> <1214279258.3001.76.camel@rzhang-dt.sh.intel.com> <alpine.LFD.1.10.0806251913090.3279@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0806251913090.3279@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.5 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26-06-08 01:16, Len Brown wrote:
> 
>> +config THERMAL_HWMON
>> +	bool "Hardware monitoring support"
>> +	depends on HWMON=y || HWMON=THERMAL
> 
> 
> for
> CONFIG_HWMON=m
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=n, always.
> 
> This is not a change to the logic of the existing ifdefs,
> but was wondering if this was your intent, Rui.

My intentioon in this case. Yes, this should be. THERMAL_HWMON is a bool 
(as in, not a tristate) that just changes THERMAL.

If THERMAL=y, we need HWMON=y or we'd get a link failure. If THERMAL=m, 
we're okay with either HWMON=y and HWMON=m and if THERMAL=n, we don't 
care one hoot about THERMAL_HWMON...

Rene.
