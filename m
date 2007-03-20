Return-Path: <linux-kernel-owner+w=401wt.eu-S933974AbXCTEXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974AbXCTEXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 00:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933978AbXCTEXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 00:23:22 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38526 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933974AbXCTEXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 00:23:21 -0400
Message-ID: <45FF6189.9080508@zytor.com>
Date: Mon, 19 Mar 2007 21:22:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, "J.H." <warthog9@kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysctl: vfs_cache_divisor
References: <20061214223718.GA3816@elf.ucw.cz>	<20061216094421.416a271e.randy.dunlap@oracle.com>	<20061216095702.3e6f1d1f.akpm@osdl.org>	<458434B0.4090506@oracle.com>	<1166297434.26330.34.camel@localhost.localdomain>	<20061219063413.GI24090@1wt.eu>	<1166511171.26330.120.camel@localhost.localdomain>	<20070106103331.48150aed.randy.dunlap@oracle.com>	<459FF60D.7080901@zytor.com>	<1168112266.2821.2.camel@entropy>	<20070106121301.d07de0c9.akpm@osdl.org>	<45A0041F.4060903@zytor.com>	<20070319122740.286f602e.randy.dunlap@oracle.com> <20070319133613.9f4881db.akpm@linux-foundation.org> <45FEF5BC.90809@oracle.com>
In-Reply-To: <45FEF5BC.90809@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
>>
>> The we duplicate all the relevant /proc knobs:
>>
>> cat /proc/sys/vm/dirty_ratio
>> 30
>> cat /proc/sys/vm/hires-dirty_ratio/
>> 300000
>>
>> Or we do something else ;)
> 
> Sounds better.  I wasn't very keen on the userspace interface that this
> exposed.  Will look at those.
> 

Okay... may be I could throw a spanner in the machinery, and suggest 
another option: perhaps we should add a way to do sysctl which can 
handle fractional (fixed-point) values... more coherent/detailed message 
tomorrow.

	-hpa
