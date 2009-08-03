Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbZHCUsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbZHCUsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZHCUsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:48:19 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37494 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbZHCUsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:48:19 -0400
Date: Mon, 3 Aug 2009 13:48:18 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: ykzhao <yakui.zhao@intel.com>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [PATCH 2/2] acpi_power_meter: hwmon driver for ACPI 4.0 power
	meters
Message-ID: <20090803204817.GA14694@plum>
Reply-To: djwong@us.ibm.com
References: <20090725004322.20709.96804.stgit@elm3a70.beaverton.ibm.com> <20090725004335.20709.52288.stgit@elm3a70.beaverton.ibm.com> <1248659067.3556.70.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248659067.3556.70.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 09:44:27AM +0800, ykzhao wrote:
> On Sat, 2009-07-25 at 08:43 +0800, Darrick J. Wong wrote:
> > This driver exposes ACPI 4.0 compliant power meters as hardware monitoring
> > devices.
> It seems OK to me. But it seems that some attributes can't be obtained
> by using the hwmon sys I/F.
>    a. Can we add a sys I/F that can exports the Power meter capability?
> display all the content of _PMC as what we have done in battery

Are you talking about all 17 fields of the _PMC return value?  Or specifically
the feature bit field "Supported Capabilities"?  The feature bits control
whether or not the corresponding sysfs attributes even show up, and the other
fields (except the string data) are all there.  I suppose it would be useful to
display the OEM data too...

>    b. Add a sys I/F that displays the name of device list measured by
> the power meter if there exists the _PMD object.

As soon as I figure out how to do that. :)

Sorry for the slow response as I was mountain climbing = no Internet.

--D
