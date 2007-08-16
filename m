Return-Path: <linux-kernel-owner+w=401wt.eu-S933497AbXHPQzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497AbXHPQzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbXHPQzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:55:08 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:33843 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554AbXHPQzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:55:07 -0400
Message-ID: <46C48160.3070401@nortel.com>
Date: Thu, 16 Aug 2007 10:54:56 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: dual Xeon hyperthread system only showing up as 2 cpus
References: <fa.5IVbZBqVHBgyu8BpsYPjQ9pqQ5M@ifi.uio.no> <46C38DB2.9040400@shaw.ca>
In-Reply-To: <46C38DB2.9040400@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Aug 2007 16:54:59.0913 (UTC) FILETIME=[2EA28390:01C7E026]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:

> You snipped the important part of the log. It's not using ACPI in 2.6.14 
> for some reason, which you need for HT to be detected. Either you didn't 
> configure it in or it's failed to enable somehow. Please post the entire 
> dmesg.

Wacky.  In 2.6.10 CONFIG_ACPI is disabled, but somehow it has 
CONFIG_ACPI_BOOT=y and CONFIG_ACPI_BLACKLIST_YEAR=0.

In 2.6.14, turning on CONFIG_ACPI allows it to detect 4 cpus.

Thanks for the help.

Chris
