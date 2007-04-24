Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbXDXIPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbXDXIPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbXDXIPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:15:47 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:51990 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbXDXIPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:15:44 -0400
Message-ID: <462DBC7A.4010600@bx.jp.nec.com>
Date: Tue, 24 Apr 2007 17:14:50 +0900
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take4 2/6] support multiple logging
References: <462605DC.2080804@bx.jp.nec.com>	<462609D1.50300@bx.jp.nec.com>	<20070419210813.a599c54f.akpm@linux-foundation.org>	<46288D11.4000801@bx.jp.nec.com>	<20070420111526.01ad7f4c.akpm@linux-foundation.org>	<20070420182109.GR11115@waste.org> <20070420120036.2a96cf8d@dxpl.pdx.osdl.net>
In-Reply-To: <20070420120036.2a96cf8d@dxpl.pdx.osdl.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> We don't really have anything that corresponds to netpoll's
>> connections at higher levels.
>>
>> I'm tempted to say we should make this work more like the dummy
>> network device. ie:
>>
>> modprobe netconsole -o netcon1 [params]
>> modprobe netconsole -o netcon2 [params]
> 
> The configuration of netconsole's looks like the configuration of routes.
> Granted you probably have more routes than netconsoles, but the interface
> issues are similar.  Netlink with a small application wouldn't be nice.
> And having /proc/net/netconsole (read-only) would be good for the netlink
> impaired.

Do you say that we had better use procfs instead of sysfs to show the 
configurations of netconsole?

If so, I have a question.
I thought that "procfs use things related to process as far as possible".
Is it no problem to use procfs here? 

-- 
Keiichi KII
NEC Corporation OSS Promotion Center
E-mail: k-keiichi@bx.jp.nec.com


