Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbXKSJp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbXKSJp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 04:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXKSJpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 04:45:19 -0500
Received: from hu-out-0506.google.com ([72.14.214.232]:48559 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbXKSJpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 04:45:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=nN5e9ot9WrbJTuUdbdN4zRvaD8OTAjmuEvv8AZcyeStGk5+y1APixWOe/8py+yb2qmHqR5R98w20X0+3FL1XLNUs8afbN+rkOdH8ge1JU4LP5fx4ecOrto6Zn+deL/Q2VZXEXz9knh76MCKpZx9POYQ5UUpLhp7C6F4GLL09VpA=
Message-ID: <47415B46.4020709@gmail.com>
Date: Mon, 19 Nov 2007 12:45:42 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org, astarikovskiy@suse.de,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix segfault when printing battery status
References: <200711182049.33355.eike-kernel@sf-tec.de>
In-Reply-To: <200711182049.33355.eike-kernel@sf-tec.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Rolf Eike Beer wrote:
> cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:19/PNP0C0A:00/power_supply/BAT1/status
>
> This leads to a stacktrace as acpi_battery_get_property() returns 0 for a 
> case where it does not set val->intval. These value is used as an array 
> index in drivers/power/power_supply_sysfs.c::power_supply_show_property(). 
> I had a situation where the value was 4096 which caused a problem as the 
> array only has 5 entries.
>
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
>   
Rolf, thanks for remainding.
Acked again,
Alex.
