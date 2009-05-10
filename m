Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528AbZEJIIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbZEJIIo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 04:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbZEJII0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 04:08:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47326
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbZEJIIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 04:08:25 -0400
Date: Sun, 10 May 2009 01:08:21 -0700 (PDT)
Message-Id: <20090510.010821.00122250.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: cfriesen@nortel.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ipconfig: handle case of delayed DHCP server
From: David Miller <davem@davemloft.net>
In-Reply-To: <m17i0pwg0w.fsf@fess.ebiederm.org>
References: <4A049C6B.9070000@nortel.com>
	<20090508.143947.207466029.davem@davemloft.net>
	<m17i0pwg0w.fsf@fess.ebiederm.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 10 May 2009 00:53:03 -0700

> David Miller <davem@davemloft.net> writes:
> 
>> From: "Chris Friesen" <cfriesen@nortel.com>
>> Date: Fri, 08 May 2009 14:56:11 -0600
>>
>>> 
>>> +	/* Is it a reply for the device we are configuring? */
>>> +	if (b->xid != ic_dev_xid) {
>>> +		if (net_ratelimit())
>>> + printk(KERN_ERR "DHCP/BOOTP: Ignoring delayed packet \n");
>>> +		goto drop_unlock;
>>
>> Please don't use such odd indentation for this printk
>> statement.
> 
> Weird it looked ok in my mailer 3 tabs in, and out to coloumn 82.  Dave someting
> word wrap it for you?

I hope it's not my arch-nemesis, format=flowed :-/
