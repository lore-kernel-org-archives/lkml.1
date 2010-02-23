Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab0BWJk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 04:40:28 -0500
Received: from mga07.intel.com ([143.182.124.22]:37285 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750930Ab0BWJk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 04:40:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,525,1262592000"; 
   d="scan'208";a="247026933"
Date: Tue, 23 Feb 2010 10:41:42 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
Message-ID: <20100223094141.GC3550@sortiz.org>
References: <4B73DAEE.5080400@compulab.co.il>
 <4B73DB4B.40501@compulab.co.il>
 <4B7D7C13.20703@compulab.co.il>
 <4B7D7CD0.7080202@oracle.com>
 <4B7D807D.9060105@compulab.co.il>
 <20100223092636.42b083f0@hyperion.delvare>
 <4B839F27.2040003@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B839F27.2040003@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

On Tue, Feb 23, 2010 at 11:25:59AM +0200, Denis Turischev wrote:
> Hi Samuel,
> Regarding renaming of sch* to isch* do you want incremental patch, or fresh version?
> 
I'll fix that myself, no worries.

Cheers,
Samuel.


> Denis
> 
> Jean Delvare wrote:
> >>+static struct mfd_cell lpc_sch_cells[] = {
> >>+	{
> >>+		.name = "isch_smbus",
> >>+		.num_resources = 1,
> >>+		.resources = &smbus_sch_resource,
> >>+	},
> >>+	{
> >>+		.name = "sch_gpio",
> >>+		.num_resources = 1,
> >>+		.resources = &gpio_sch_resource,
> >>+	},
> >>+};
> >
> >These names are nicely inconsistent. What about "isch_gpio"?
> >
> 
> >>+obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
> >
> >I don't like this name either. There is another vendor (SMSC) shipping
> >LPC devices with "SCH" in their names, so there is room for confusion.
> >"isch" makes it clearer that we are talking about the Intel ones.
> >
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
