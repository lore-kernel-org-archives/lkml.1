Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYFWI30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYFWI30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYFWI3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:29:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35613 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbYFWI3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:29:14 -0400
Message-ID: <485F5EA5.9050503@jp.fujitsu.com>
Date: Mon, 23 Jun 2008 17:28:21 +0900
From: Taku Izumi <izumi.taku@jp.fujitsu.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH 0/3] e1000,e1000e,igb: make ioport free for adapters that
 need NO ioport resources
References: <485B1B8E.1060108@jp.fujitsu.com> <485D4630.1090007@intel.com>
In-Reply-To: <485D4630.1090007@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Auke

>> * [PATCH 1/3] e1000: make ioport free
>> * [PATCH 2/3] e1000e: make ioport free
>> * [PATCH 3/3] igb: make ioport free
> 
> I think patch 2 and 3 are way too large since igb and e1000e can be totally ioport
> free at all times. There is no need to keep compatibility code for ioport in those
> drivers as it's unlikely that this will ever be needed.

I left an old implementation in case adapters that need ioport resources appear,
but it's true that these codes are a little redundant for igb and e1000e drivers.

> So, perhaps you can remove the ioport code from those 2 drivers (e1000e/igb)
> completely and resubmit to Jeff Kirsher?

  OK, I'll send them later.

Best regards,
Taku Izumi <izumi.taku@jp.fujitsu.com>

