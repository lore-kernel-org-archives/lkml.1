Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab0BWJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 04:25:27 -0500
Received: from compulab.co.il ([67.18.134.219]:39153 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab0BWJZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 04:25:24 -0500
Message-ID: <4B839F27.2040003@compulab.co.il>
Date: Tue, 23 Feb 2010 11:25:59 +0200
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
References: <4B73DAEE.5080400@compulab.co.il>	<4B73DB4B.40501@compulab.co.il>	<4B7D7C13.20703@compulab.co.il>	<4B7D7CD0.7080202@oracle.com>	<4B7D807D.9060105@compulab.co.il> <20100223092636.42b083f0@hyperion.delvare>
In-Reply-To: <20100223092636.42b083f0@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,
Regarding renaming of sch* to isch* do you want incremental patch, or fresh version?

Denis

Jean Delvare wrote:
>> +static struct mfd_cell lpc_sch_cells[] = {
>> +	{
>> +		.name = "isch_smbus",
>> +		.num_resources = 1,
>> +		.resources = &smbus_sch_resource,
>> +	},
>> +	{
>> +		.name = "sch_gpio",
>> +		.num_resources = 1,
>> +		.resources = &gpio_sch_resource,
>> +	},
>> +};
> 
> These names are nicely inconsistent. What about "isch_gpio"?
> 

>> +obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
> 
> I don't like this name either. There is another vendor (SMSC) shipping
> LPC devices with "SCH" in their names, so there is room for confusion.
> "isch" makes it clearer that we are talking about the Intel ones.
> 

