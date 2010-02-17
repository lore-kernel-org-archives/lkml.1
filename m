Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab0BQOgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 09:36:31 -0500
Received: from mga12.intel.com ([143.182.124.36]:62586 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756917Ab0BQOg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 09:36:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,491,1262592000"; 
   d="scan'208";a="245004303"
Date: Wed, 17 Feb 2010 15:37:44 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Jean Delvare <khali@linux-fr.org>, Denis Turischev <denis@compulab.co.il>,
       David Brownell <david-b@pacbell.net>,
       LKML <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
Message-ID: <20100217143743.GB3011@sortiz.org>
References: <4B73DAEE.5080400@compulab.co.il>
 <4B73DB4B.40501@compulab.co.il>
 <201002161157.47196.david-b@pacbell.net>
 <20100216224947.5c46ff86@hyperion.delvare>
 <4B7BBEE5.3040104@compulab.co.il>
 <20100217114433.6a405bd3@hyperion.delvare>
 <4B7BE292.5080700@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7BE292.5080700@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Wed, Feb 17, 2010 at 02:35:30PM +0200, Mike Rapoport wrote:
> Samuel,
> 
> Jean Delvare wrote:
> > On Wed, 17 Feb 2010 12:03:17 +0200, Denis Turischev wrote:
> >> Jean Delvare wrote:
> >>> Might be a good idea to use acpi_check_resource_conflict() or similar
> >>> before instantiating the platform devices.
> >> May be it worth to add such resource check directly to mfd_add_device function?
> > 
> > I'm not sure. I suspect that many MFD devices are never used on
> > ACPI-aware systems, so it might be considered overkill. OTOH the calls
> > resolve to empty stubs when ACPI is disabled so... I have no objection,
> > but I'll leave the decision to somebody else ;)
> > 
> 
> What do you think? Shall we add something like mfd_verify_resources that will call
> acpi_check_region or something similar?
Yes, that sounds like a reasonable idea. We should probably call
acpi_check_resource_conflict() straight from mfd_add_device(). I'll do that,
no need for Denis to add that patch for its code to be merged.

Cheers,
Samuel.


> 
> -- 
> Sincerely yours,
> Mike.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
