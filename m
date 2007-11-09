Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbXKIJhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbXKIJhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 04:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbXKIJhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 04:37:09 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:38963 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751501AbXKIJhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 04:37:08 -0500
Message-ID: <47342A2B.5020006@suse.de>
Date: Fri, 09 Nov 2007 12:36:43 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rjw@sisk.pl, hannes-kernel@saeurebad.de, listen@selfservix.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.24-rc1: OOPS at  acpi_battery_update
References: <1193652664.22149.4.camel@localhost>	<200711050118.34610.rjw@sisk.pl>	<20071108155344.GA12231@cataract>	<200711081717.00421.rjw@sisk.pl>	<47333ACB.6070408@suse.de> <20071108203451.1b7f28c0.akpm@linux-foundation.org>
In-Reply-To: <20071108203451.1b7f28c0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> A> On Thu, 08 Nov 2007 19:35:23 +0300 Alexey Starikovskiy <astarikovskiy@suse.de> wrote:
>> [remove_cycle_at_battery_removal.patch  text/x-patch (1.7KB)]
>> ACPI: Battery: remove cycle from battery removal.
>>
>> From: Alexey Starikovskiy <astarikovskiy@suse.de>
>>
>> get_property() should not call battery_update() on absent battery to
>> avoid cycle and oops.
>>
>> Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
>> Tested-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> 
> A patch similar to this one but with an identical changelog was merged into
> Len's tree on November 2.
> 
> If it had been promptly merged into mainline then quite a lot of people's
> time would not have been wasted.
> 
Andrew,
should I send such patches directly to you/Linus?

Regards,
Alex
