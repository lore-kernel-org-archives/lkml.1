Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab0BQMgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 07:36:45 -0500
Received: from compulab.co.il ([67.18.134.219]:48952 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab0BQMgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 07:36:43 -0500
Message-ID: <4B7BE292.5080700@compulab.co.il>
Date: Wed, 17 Feb 2010 14:35:30 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: Denis Turischev <denis@compulab.co.il>,
       David Brownell <david-b@pacbell.net>,
       LKML <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
References: <4B73DAEE.5080400@compulab.co.il>	<4B73DB4B.40501@compulab.co.il>	<201002161157.47196.david-b@pacbell.net>	<20100216224947.5c46ff86@hyperion.delvare>	<4B7BBEE5.3040104@compulab.co.il> <20100217114433.6a405bd3@hyperion.delvare>
In-Reply-To: <20100217114433.6a405bd3@hyperion.delvare>
Content-Type: text/plain; charset=US-ASCII
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

Samuel,

Jean Delvare wrote:
> On Wed, 17 Feb 2010 12:03:17 +0200, Denis Turischev wrote:
>> Jean Delvare wrote:
>>> Might be a good idea to use acpi_check_resource_conflict() or similar
>>> before instantiating the platform devices.
>> May be it worth to add such resource check directly to mfd_add_device function?
> 
> I'm not sure. I suspect that many MFD devices are never used on
> ACPI-aware systems, so it might be considered overkill. OTOH the calls
> resolve to empty stubs when ACPI is disabled so... I have no objection,
> but I'll leave the decision to somebody else ;)
> 

What do you think? Shall we add something like mfd_verify_resources that will call
acpi_check_region or something similar?


-- 
Sincerely yours,
Mike.
