Return-Path: <linux-kernel-owner+w=401wt.eu-S1764862AbYEATB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764862AbYEATB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762314AbYEATBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:01:49 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:47651 "EHLO
	outbound2-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762236AbYEATBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:01:48 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <481A1399.8020304@am.sony.com>
Date: Thu, 1 May 2008 12:01:45 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@gmail.com>
CC: Tony Breeds <tony@bakeyournoodle.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com,
       akpm@linux-foundation.org, LinuxPPC-dev <linuxppc-dev@ozlabs.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: powerpc boot regression
References: <20080429.231241.221824292.davem@davemloft.net>	 <20080501051304.GM20457@bakeyournoodle.com> <1209653507.27240.7.camel@badari-desktop>
In-Reply-To: <1209653507.27240.7.camel@badari-desktop>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 May 2008 19:01:46.0012 (UTC) FILETIME=[CD365DC0:01C8ABBD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Badari Pulavarty wrote:
> On Thu, 2008-05-01 at 15:13 +1000, Tony Breeds wrote:
>> On Tue, Apr 29, 2008 at 11:12:41PM -0700, David Miller wrote:
>> > 
>> > This commit causes bootup failures on sparc64:
>> > 
>> > commit 86f6dae1377523689bd8468fed2f2dd180fc0560
>> > Author: Yasunori Goto <y-goto@jp.fujitsu.com>
>> > Date:   Mon Apr 28 02:13:33 2008 -0700
>> > 
>> >     memory hotplug: allocate usemap on the section with pgdat
>> 
>> 
>> <snip>
>> 
>> We're seeing a boot failure on powerpc.  git bisect points the problem
>> at this commit.   However reverting just this one comitt doesn't fix the
>> regression.  I also needed to revert
>> 04753278769f3b6c3b79a080edb52f21d83bf6e2 (memory hotplug: register
>> section/node id to free")
>> 
>> Problem seen on power4, power5 and ps3.
> 
> I don't see the problem on my power5 machine. Can you send the
> config ? Is CONFIG_SPARSEMEM_VMEMMAP enabled ?


The bug is hit with ps3_defconfig.  It does not have
CONFIG_SPARSEMEM_VMEMMAP set.


-Geoff

