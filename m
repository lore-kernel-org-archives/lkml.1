Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYFZA5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYFZA5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 20:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYFZA52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 20:57:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:27291 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbYFZA51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 20:57:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,705,1204531200"; 
   d="scan'208";a="345634791"
Subject: Re: [PATCH 2.6.26-rc] ACPI Thermal Zone driver breaks lm-sensors 2
	userspace
From: Zhang Rui <rui.zhang@intel.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Hans de Goede <j.w.r.degoede@hhs.nl>, Jean Delvare <khali@linux-fr.org>,
       linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4862D704.80607@keyaccess.nl>
References: <fa.4PGqX9CuLbgiTimfCcon+PlAMxk@ifi.uio.no>
	 <fa.PWu620xEt5OlYdOezvRtQriuNjM@ifi.uio.no> <48605935.5070407@shaw.ca>
	 <alpine.LFD.1.10.0806232004480.2926@woody.linux-foundation.org>
	 <1214279258.3001.76.camel@rzhang-dt.sh.intel.com>
	 <alpine.LFD.1.10.0806251913090.3279@localhost.localdomain>
	 <4862D704.80607@keyaccess.nl>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 08:57:56 +0800
Message-Id: <1214441876.3001.175.camel@rzhang-dt.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-26 at 07:38 +0800, Rene Herman wrote:
> On 26-06-08 01:16, Len Brown wrote:
> >
> >> +config THERMAL_HWMON
> >> +    bool "Hardware monitoring support"
> >> +    depends on HWMON=y || HWMON=THERMAL
> >
> >
> > for
> > CONFIG_HWMON=m
> > CONFIG_THERMAL=y
> > CONFIG_THERMAL_HWMON=n, always.
> >
> > This is not a change to the logic of the existing ifdefs,
> > but was wondering if this was your intent, Rui.
> 
> My intentioon in this case. Yes, this should be. THERMAL_HWMON is a
> bool
> (as in, not a tristate) that just changes THERMAL.
> 
> If THERMAL=y, we need HWMON=y or we'd get a link failure. If
> THERMAL=m,
> we're okay with either HWMON=y and HWMON=m and if THERMAL=n, we don't
> care one hoot about THERMAL_HWMON...
Agree.

Acked-by: Zhang Rui <rui.zhang@intel.com>



