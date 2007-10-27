Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbXJ0QQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbXJ0QQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 12:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbXJ0QQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 12:16:48 -0400
Received: from hpsmtp-eml15.KPNXCHANGE.COM ([213.75.38.115]:42279 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753134AbXJ0QQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 12:16:47 -0400
From: Frans Pop <elendil@planet.nl>
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: [2.624-rc1 regression] lost battery information
Date: Sat, 27 Oct 2007 18:16:44 +0200
User-Agent: KMail/1.9.7
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200710262024.06012.arvidjaar@mail.ru> <200710271855.52866.arvidjaar@mail.ru> <47235727.30808@gmail.com>
In-Reply-To: <47235727.30808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710271816.44978.elendil@planet.nl>
X-OriginalArrivalTime: 27 Oct 2007 16:16:45.0251 (UTC) FILETIME=[C4A6E130:01C818B4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. Things seem to have progressed since I was last online :-)

With Alexey's original patch I also get a number of times:
ACPI: element[12]->type = 1, expected string

On Saturday 27 October 2007, Alexey Starikovskiy wrote:
> As you wish... :) Please check the attached patch.

With 'battery_allow_extract_string_from_integer.patch' all info in /proc is 
back and I now also see the new files in /sys/class/power_supply.

The "OEM info" field (line 13 in BAT1/info) is empty, just as it was empty 
in 2.6.23 too.

Tested-by: Frans Pop <elendil@planet.nl>

Cheers,
Frans Pop
