Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbZIAAqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbZIAAqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 20:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZIAAqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 20:46:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:65039 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbZIAAqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 20:46:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182581808"
Subject: Re: [PATCH 2/6] thermal: sysfs-api.txt - document passive
	attribute for thermal zones
From: Zhang Rui <rui.zhang@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Thomas, Sujith" <sujith.thomas@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <200908311320.00632.elendil@planet.nl>
References: <1251303445-25317-1-git-send-email-elendil@planet.nl>
	 <1251303445-25317-3-git-send-email-elendil@planet.nl>
	 <1251706691.3483.169.camel@rzhang-dt>
	 <200908311320.00632.elendil@planet.nl>
Content-Type: text/plain
Date: Tue, 01 Sep 2009 08:44:42 +0800
Message-Id: <1251765882.3483.193.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-31 at 19:19 +0800, Frans Pop wrote:
> On Monday 31 August 2009, Zhang Rui wrote:
> > > +passive
> > > +	Attribute is only present for zones which do not have a passive
> > > +	cooling policy (_PSV) defined in ACPI.
> >
> > We should not involve any platform specific stuff in this
> > documentation. how about "Attribute is only present for zones in which
> > the passive cooling policy is not supported by native thermal driver"
> [...]
> > > -If the processor is listed in _PSL method, and the fan is listed in
> > > _AL0 -method, the sys I/F structure will be built like this:
> > > +If the processor is listed in _PSL method, the fan is listed in _AL0
> > > +method, and the zone has a _PSV method, the sys I/F structure will
> > > be +built like this:
> >
> > For an ACPI thermal zone, supporting passive cooling means that both
> > _PSL and _PSV are available.
> > so I don't think we need to change this. :)
> 
> OK. Updated patch below.
> 
> 
> From: Frans Pop <elendil@planet.nl>
> Subject: thermal: sysfs-api.txt - document passive attribute for thermal zones
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Sujith Thomas <sujith.thomas@intel.com>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> 
Acked-by: Zhang Rui <rui.zhang@intel.com>

thanks,
rui
> diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
> index 895337f..a87dc27 100644
> --- a/Documentation/thermal/sysfs-api.txt
> +++ b/Documentation/thermal/sysfs-api.txt
> @@ -199,6 +199,15 @@ cdev[0-*]_trip_point
>  	point.
>  	RO, Optional
>  
> +passive
> +	Attribute is only present for zones in which the passive cooling
> +	policy is not supported by native thermal driver. Default is zero
> +	and can be set to a temperature (in millidegrees) to enable a
> +	passive trip point for the zone. Activation is done by polling
> +	with an interval of 1 second.
> +	Unit: millidegrees Celsius
> +	RW, Optional
> +
>  *****************************
>  * Cooling device attributes *
>  *****************************

