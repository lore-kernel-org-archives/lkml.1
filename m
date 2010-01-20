Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274Ab0ATOnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab0ATOnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 09:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311Ab0ATOnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 09:43:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:48877 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab0ATOni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 09:43:38 -0500
Subject: Re: [PATCH] perf tools: fix write_event()
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263996897.4283.1065.camel@laptop>
References: <4B570657.5090105@cn.fujitsu.com>
	 <1263994901.4283.1060.camel@laptop> <1263995096.4283.1062.camel@laptop>
	 <20100120140942.GP14636@ghostprotocols.net>
	 <1263996897.4283.1065.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 15:43:30 +0100
Message-ID: <1263998610.4283.1076.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 15:14 +0100, Peter Zijlstra wrote:

> > > > Uhm, how why? it didn't used to know about events and just copied the
> > > > data.
> > > 
> > > looks like acme wrecked it in f5a2c3dc.. anyway the fix is wrong, record
> > > should not know or care about the actual events and simply write data
> > > out.
> > 
> > Oh well, I guess then we should do that after record finishes,
> > reprocessing all the data in the file.
> 
> Why do we need it at all?

To clarify, we want to keep the record cycle as small/fast as possible
in order to minimize permutation of the system we're recording.

