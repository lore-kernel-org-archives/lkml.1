Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbYAVH4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbYAVH4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 02:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbYAVH4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 02:56:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:31186 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbYAVH4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 02:56:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,232,1199692800"; 
   d="scan'208";a="292285152"
Subject: Re: [PATCH 6/10] ACPI: register ACPI Video LCD as generic thermal
	cooling device
From: Zhang Rui <rui.zhang@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Thomas, Sujith" <sujith.thomas@intel.com>
In-Reply-To: <20080118014254.GA14818@srcf.ucam.org>
References: <1200556282.2935.122.camel@acpi-sony.sh.intel.com>
	 <20080117122431.GA32133@srcf.ucam.org>
	 <1200619900.2935.161.camel@acpi-sony.sh.intel.com>
	 <20080118014254.GA14818@srcf.ucam.org>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 16:01:42 +0800
Message-Id: <1200988902.7424.14.camel@acpi-sony.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Matthew,

On Fri, 2008-01-18 at 09:42 +0800, Matthew Garrett wrote:
> On Fri, Jan 18, 2008 at 09:31:40AM +0800, Zhang Rui wrote:
> 
> > Just like I don't think lcd should be used for ACPI thermal
> management
> > before I saw it is listed in _TZD and intel_menlow requires to
> throttle
> > it when overheating, why not let the individual drivers implement
> the
> > callbacks if there is clearly a request to do this.
> > And we can add this to the generic acpi_device struct then if this
> is a
> > common feature for all ACPI devices.
> 
> It'll probably never be common for all ACPI devices,
I agree.
>  but it's already
> required for three types. I think that's a strong argument for making
> it generic.
I don't think it's worth doing this as it's only the common feature for
three ACPI devices.
> > Well, you're right.
> > But in order to throttle the lcd, this is reasonable, right?
> 
> Moving the common code into its own routine and then calling that from
> each of the others would probably work.
Yes.
I can send an on top patch if the patch "Rationalise ACPI backlight
implementation" is applied.

Thanks,
Rui

