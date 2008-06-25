Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbYFYXQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbYFYXQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYFYXQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:16:40 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:58758 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbYFYXQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:16:39 -0400
Date: Wed, 25 Jun 2008 19:16:15 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2.6.26-rc] ACPI Thermal Zone driver breaks lm-sensors 2
 userspace
In-reply-to: <1214279258.3001.76.camel@rzhang-dt.sh.intel.com>
X-X-Sender: lenb@localhost.localdomain
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Hans de Goede <j.w.r.degoede@hhs.nl>, Jean Delvare <khali@linux-fr.org>,
       linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.1.10.0806251913090.3279@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <fa.4PGqX9CuLbgiTimfCcon+PlAMxk@ifi.uio.no>
 <fa.PWu620xEt5OlYdOezvRtQriuNjM@ifi.uio.no> <48605935.5070407@shaw.ca>
 <alpine.LFD.1.10.0806232004480.2926@woody.linux-foundation.org>
 <1214279258.3001.76.camel@rzhang-dt.sh.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> +config THERMAL_HWMON
> +	bool "Hardware monitoring support"
> +	depends on HWMON=y || HWMON=THERMAL


for
CONFIG_HWMON=m
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=n, always.

This is not a change to the logic of the existing ifdefs,
but was wondering if this was your intent, Rui.

-Len

> -#if defined(CONFIG_HWMON) ||	\
> -	(defined(CONFIG_HWMON_MODULE) && defined(CONFIG_THERMAL_MODULE))
> +#if defined(CONFIG_THERMAL_HWMON)
> +
>  /* hwmon sys I/F */

