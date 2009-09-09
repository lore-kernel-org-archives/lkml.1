Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbZIICAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbZIICAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbZIICAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:00:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35163 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZIICAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:00:51 -0400
Subject: Re: [PATCH 2/2] tracing/filters: use strcmp() instead of strncmp()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AA70315.7010600@cn.fujitsu.com>
References: <4A1F9FAC.6020506@cn.fujitsu.com>
	 <c62985530905290651id2435bfx7f57ec561fe366e3@mail.gmail.com>
	 <4A20F71F.6030703@cn.fujitsu.com> <20090530135236.GB5969@nowhere>
	 <4A223F7E.3090203@cn.fujitsu.com> <20090531132853.GA6013@nowhere>
	 <4A236B0B.3000604@cn.fujitsu.com> <20090601130928.GA6000@nowhere>
	 <4A247875.9010507@cn.fujitsu.com>
	 <1252379033.21261.2060.camel@gandalf.stny.rr.com>
	 <4AA70315.7010600@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 08 Sep 2009 22:00:52 -0400
Message-Id: <1252461652.11070.4.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 09:21 +0800, Li Zefan wrote:
> > Not sure this is an issue. I may be a little out of context here, but
> > isn't addr coming from the event? The event is made in the kernel and
> > should be fine?
> > 
> > What ever the case, the bug you originally mentioned is still there (I
> > just tried it out on the latest tip). That is, name == et will match
> > "eth0".
> > 
> 
> Strange. I fixed it with this commit:
> 
> ========
> commit 7d536cb3fb9993bdcd5a2fbaa6b0670ded4e101c
> Author: Li Zefan <lizf@cn.fujitsu.com>
> Date:   Thu Jul 16 10:54:02 2009 +0800
> 
>     tracing/events: record the size of dynamic arrays

My fault, I booted into the wrong (older) kernel when I did my test.

Sorry for the noise.

-- Steve


