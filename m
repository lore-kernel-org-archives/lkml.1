Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab0CISqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:46:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42678 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab0CISqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:46:15 -0500
X-Authority-Analysis: v=1.0 c=1 a=drjUTJznMZEA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=IN5h458DF_uzvNNN74AA:9 a=swljyVWDS72NeliHE5A1LyGPqJkA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [BUG] WARNING: at kernel/trace/ring_buffer.c:3420
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
In-Reply-To: <1268155703.10871.1872.camel@gandalf.stny.rr.com>
References: <4B94936B.8030409@cn.fujitsu.com>
	 <4B949E43.2010906@cn.fujitsu.com>
	 <1268060596.10871.1805.camel@gandalf.stny.rr.com>
	 <1268060858.10871.1807.camel@gandalf.stny.rr.com>
	 <4B95C1FC.9030307@cn.fujitsu.com>
	 <1268155703.10871.1872.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 09 Mar 2010 13:46:12 -0500
Message-ID: <1268160372.10871.1874.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 12:28 -0500, Steven Rostedt wrote:
> On Tue, 2010-03-09 at 11:35 +0800, Lai Jiangshan wrote:

> With Li's test, I was able to trigger the ring_buffer warning about
> resetting while committing. I was still able to trigger it with your
> patch to move the ring buffer disable code. But I did not trigger it
> with both the ring buffer disable code _and_ your RCU fix.

Spoke too soon. I hit it again. But I think I know why.

-- Steve



