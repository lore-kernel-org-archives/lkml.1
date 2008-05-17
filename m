Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbYEQPFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbYEQPFk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbYEQPFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:05:33 -0400
Received: from dsl093-193-175.stl1.dsl.speakeasy.net ([66.93.193.175]:55864
	"EHLO hades.sngx.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753548AbYEQPFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:05:32 -0400
Message-ID: <482EF465.2050205@sngx.net>
Date: Sat, 17 May 2008 10:06:13 -0500
From: James Cammarata <jimi@sngx.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Rick Jones <rick.jones2@hp.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH updated] net: add ability to clear per-interface	network
 statistics via procfs
References: <482DA5B6.1020606@sngx.net> <20080516.130004.18881610.davem@davemloft.net> <482DE9EC.3060803@hp.com>
In-Reply-To: <482DE9EC.3060803@hp.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> We saw your initial patch posting, you don't need to send this
>> again.
>>
>> netdev added to CC:

I had regenerated the diff against .25.4 and made a few changes so I resubmitted.
Sorry if I made it seem like I was spamming the patch.

> I don't wish to suggest I don't like the change - I've used similar 
> features on "other oses" in the past, but when something like this has 
> come-up in the past, haven't there been concerns about MIBs and SNMP and 
> whatnot?
> 
> rick jones
> ftp://ftp.cup.hp.com/dist/networking/tools - beforeafter - subtract one 
> set of stats from another...

Yes, this would definitely be a caveat, as it could cause problems if the software
takes a baseline once, and calculates differences from that ever after.  For others,
it would cause a hiccup where stats show as being negative for one period.

However, I think the benefit of being able to troubleshoot issues on an interface 
in a non-invasive manner outweigh the downside here.  Like you say, this ability 
is already found elsewhere, most namely in network devices like Ciscos, and the 
concern for clearing stats there does not exist.
