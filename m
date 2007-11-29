Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbXK2I6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbXK2I6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 03:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbXK2I6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 03:58:35 -0500
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:53670 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754158AbXK2I6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:58:34 -0500
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 6/6] tick: add a missing dot in prink
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org
In-reply-To: <474E6BD0.20103@cn.fujitsu.com>
References: <474E6BD0.20103@cn.fujitsu.com>
Message-Id: <E1IxfE8-0000Sr-9w@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Thu, 29 Nov 2007 09:58:32 +0100
X-OriginalArrivalTime: 29 Nov 2007 08:58:32.0700 (UTC) FILETIME=[04B3BBC0:01C83266]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Add a missing '.' in prink information.
> -			printk(" no tick device\n");
> +			printk(" no tick device.\n");

I wonder if that is correct. CodingStyle says:
                Chapter 13: Printing kernel messages
   [...]
   Kernel messages do not have to be terminated with a period.

I personally think that rule could be made a bit stricter as for example
dmesg output currently looks fairly inconsistent with some messages
terminated with a period while most messages are not and have been wondering
if I should file patches to _remove_ periods.

Maybe the rule should be changed to:
   Kernel messages should not be terminated with a period, unless a single
   message contains multiple sentences.
?

Cheers,
FJP
