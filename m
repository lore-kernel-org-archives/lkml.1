Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662Ab0ATVdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab0ATVdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 16:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254Ab0ATVdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 16:33:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:33635 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab0ATVdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 16:33:44 -0500
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
In-Reply-To: <1263994448.4283.1052.camel@laptop>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
	 <1263994448.4283.1052.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 22:33:24 +0100
Message-ID: <1264023204.4283.1124.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 14:34 +0100, Peter Zijlstra wrote:

> So how about PERF_TYPE_{CORE,NODE,SOCKET} like things?

OK, so I read most of the intel uncore stuff, and it seems to suggest
you need a regular pmu event to receive uncore events (chained setup),
this seems rather retarded since it wastes a perfectly good pmu event
and makes configuring all this more intricate...

A well, nothing to be done about that I guess.. 



