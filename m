Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYKOQbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYKOQbr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 11:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbYKOQbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 11:31:38 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:47986 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYKOQbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 11:31:37 -0500
Message-ID: <491EF942.1090709@cosmosbay.com>
Date: Sat, 15 Nov 2008 17:30:58 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Mikael Pettersson <mikpe@it.uu.se>,
       Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net,
       Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jkosina@suse.cz>,
       Jiri Benc <jbenc@suse.cz>, Vilem Marsik <vmarsik@suse.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: Oprofile : need to adjust PC by 16 bytes
References: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz> <20081113212446.GA5694@elte.hu> <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz> <20081113213744.GA8429@elte.hu> <491CA0DC.8070405@cosmosbay.com> <491D987F.1000301@cosmosbay.com> <18717.44751.459961.277998@harpo.it.uu.se> <491DB391.2040701@cosmosbay.com> <20081114175056.GK3810@one.firstfloor.org>
In-Reply-To: <20081114175056.GK3810@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 15 Nov 2008 17:31:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
>>> And no, blindly subtracting 16 from IP is not a fix.
>> Who mentioned a fix ? I am only giving more fuel to Intel guys so they
>> hopefully can give us a working oprofile.
> 
> You would need to implement PEBS support to avoid that problem. But it's a big
> task. perfmon2 implements it already.
> 

Thanks for the information.

Hum, so I grabbed perfmon2 git tree, installed various tools...

I am quite new to pfmon and tried :

# pfmon --system-wide
sizeof=64 44
<press ENTER to stop session>

Then started "tbench 8", and got a kernel panic after 6 seconds.


I was using oprofile like this

opcontrol --vmlinux=/path/vmlinux --start
// doing some benchmarking...
opreport -l vmlinux | head -n 40


What would be a working equivalent for perfmon2 based tools ?

Thanks


