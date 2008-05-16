Return-Path: <linux-kernel-owner+w=401wt.eu-S1759059AbYEPUJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059AbYEPUJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYEPUJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:09:19 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:37379 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbYEPUJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:09:19 -0400
Message-ID: <482DE9EC.3060803@hp.com>
Date: Fri, 16 May 2008 13:09:16 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jimi@sngx.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH updated] net: add ability to clear per-interface	network
 statistics via procfs
References: <482DA5B6.1020606@sngx.net> <20080516.130004.18881610.davem@davemloft.net>
In-Reply-To: <20080516.130004.18881610.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: James Cammarata <jimi@sngx.net>
> Date: Fri, 16 May 2008 10:18:14 -0500
> 
> We saw your initial patch posting, you don't need to send this
> again.
> 
> netdev added to CC:
> 
> 
>>From: James Cammarata <jimi@sngx.net>
>>
>> Added the ability to write to /proc/net/dev in order to clear the
>> interface counters for a given interface.  The ability to zero out
>> counters (especially the error counters) is extremely useful when
>> troubleshooting interface issues.  Now diffed against 2.6.25.4, and
>> added some sanity checking.
>>
>>Syntax:
>>  echo 'net clear-stats ifdev' > /proc/net/dev
>>Where "ifdev" is the device name you wish to clear.

I don't wish to suggest I don't like the change - I've used similar 
features on "other oses" in the past, but when something like this has 
come-up in the past, haven't there been concerns about MIBs and SNMP and 
whatnot?

rick jones
ftp://ftp.cup.hp.com/dist/networking/tools - beforeafter - subtract one 
set of stats from another...
