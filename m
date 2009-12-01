Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbZLARtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbZLARtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZLARtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:49:32 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:43340 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbZLARtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:49:32 -0500
Message-ID: <4B155669.5050402@oracle.com>
Date: Tue, 01 Dec 2009 09:46:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: mike@mspradling.com
CC: Johannes Berg <johannes@sipsolutions.net>, davem@davemloft.net,
       hugh.dickins@ticali.co.uk, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed bug in Wireless Extension Code (CONFIG_WEXT_CORE).
References: <1258936602-6110-1-git-send-email-mike@mspradling.com> <1258969541.7094.138.camel@johannes.local> <20091123154225.GA26103@MSServer> <1258991626.7094.174.camel@johannes.local> <20091124011202.GC26103@MSServer>
In-Reply-To: <20091124011202.GC26103@MSServer>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B1556DC.0022:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Spradling wrote:
> Sorry, I lost my config file and haven't been able to reproduce it.
> If I come across this again I will email you directly.


> --
> Mike Spradling
> 
> On Mon, Nov 23, 2009 at 04:53:46PM +0100, Johannes Berg wrote:
>> On Mon, 2009-11-23 at 10:42 -0500, Michael Spradling wrote:
>>> I don't think its a Kconfig issue, see notes below.  However,
>>> I have included my config file just in case I may be wrong.
>> You config file doesn't have _any_ wireless options set. Not even
>> CONFIG_NET.
>>
>> johannes

All of the cases that I have seen where call_commit_handler() is undefined
have been kconfig errors -- mostly in drivers/staging/.

If you do have this problem again, please be sure to send the problem
.config file.

-- 
~Randy
