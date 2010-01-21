Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947Ab0AUIgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0AUIgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 03:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025Ab0AUIgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 03:36:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:39317 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab0AUIgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 03:36:23 -0500
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>
In-Reply-To: <4B57907E.5000207@linux.vnet.ibm.com>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
	 <1263994448.4283.1052.camel@laptop> <1264023204.4283.1124.camel@laptop>
	 <4B57907E.5000207@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 09:36:09 +0100
Message-ID: <1264062969.4283.1132.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 15:23 -0800, Corey Ashford wrote:
> If so, that's an interesting idea, but I think it still 
> leaves open the problem of how to actually relate those address to the real 
> hardware, especially in the case of using a hypervisor which has provided you a 
> small subset of the physical hardware in the system. 

Well, I'm tempted to say that's a problem for the virt guys :-)

One way one could solve that is by having the topology information
include the virt<->phys map, so that you can find the physical node from
the virtual cpu number.

Going to be interesting though, but then, virt seems to be about
creating problems where there were none before.

