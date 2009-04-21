Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZDURBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZDURBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbZDURBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:01:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479AbZDURBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:01:41 -0400
Date: Tue, 21 Apr 2009 09:50:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stephen Hemminger <shemminger@vyatta.com>
cc: Paul Mackerras <paulus@samba.org>, paulmck@linux.vnet.ibm.com,
       Eric Dumazet <dada1@cosmosbay.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       David Miller <davem@davemloft.net>, kaber@trash.net,
       jeff.chua.linux@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v11)
In-Reply-To: <20090421094350.1e00207a@nehalam>
Message-ID: <alpine.LFD.2.00.0904210947500.2199@localhost.localdomain>
References: <alpine.LFD.2.00.0904151705120.4042@localhost.localdomain> <49E72E83.50702@trash.net> <20090416.153354.170676392.davem@davemloft.net> <20090416234955.GL6924@linux.vnet.ibm.com> <20090417012812.GA25534@linux.vnet.ibm.com> <20090418094001.GA2369@ioremap.net>
 <20090418141455.GA7082@linux.vnet.ibm.com> <20090420103414.1b4c490f@nehalam> <49ECBE0A.7010303@cosmosbay.com> <18924.59347.375292.102385@cargo.ozlabs.ibm.com> <20090420215827.GK6822@linux.vnet.ibm.com> <18924.64032.103954.171918@cargo.ozlabs.ibm.com>
 <20090420160121.268a8226@nehalam> <alpine.LFD.2.00.0904210831560.2199@localhost.localdomain> <20090421094350.1e00207a@nehalam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Apr 2009, Stephen Hemminger wrote:
> 
> Ah a nice day, with Linus giving constructive feedback. Too bad he has
> to channel it out of the dark side.

I already flamed that patch at least once before. People didn't react. 

What do I have to do to make people listen? I'm sorry, but I'm not going 
to send you flowers with a card saying "Hope you do better next time!".

I realize that the flowers might be friendlier, but I have absolutely no 
incentive to be friendly to just bad code. I have even _less_ incentive 
when my first "that sucks" is apparently totally ignored. So now I spelled 
it out why it sucks, but I sure as hell didn't have any reason to be 
polite about it.

			Linus
