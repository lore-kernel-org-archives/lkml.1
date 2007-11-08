Return-Path: <linux-kernel-owner+w=401wt.eu-S1761565AbXKHQMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbXKHQMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 11:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760289AbXKHQMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 11:12:03 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:60212 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759587AbXKHQMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 11:12:01 -0500
Message-ID: <47333549.90505@suse.de>
Date: Thu, 08 Nov 2007 19:11:53 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Johannes Weiner <hannes-kernel@saeurebad.de>,
       "Michael (rabenkind) Brandstetter" <listen@selfservix.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc1: OOPS at  acpi_battery_update
References: <1193652664.22149.4.camel@localhost> <200711050118.34610.rjw@sisk.pl> <20071108155344.GA12231@cataract> <200711081717.00421.rjw@sisk.pl>
In-Reply-To: <200711081717.00421.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday, 8 of November 2007, Johannes Weiner wrote:
>> Hi,
>>
>> is there any reason, why acpi_battery_get_property() should call
>> acpi_battery_update() at all?
> 
> Alex?
If someone wants to read stale values, he could comment out acpi_battery_update.

Regards,
Alex.
