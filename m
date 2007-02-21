Return-Path: <linux-kernel-owner+w=401wt.eu-S1423079AbXBUUOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423079AbXBUUOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423077AbXBUUOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:14:06 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41800 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423081AbXBUUOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:14:04 -0500
Date: Wed, 21 Feb 2007 12:13:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, npiggin@suse.de,
       rostedt@goodmis.org
Subject: Re: [patch 1/2] sched: fix idle load balancing in softirqd context
Message-Id: <20070221121351.35faf008.akpm@linux-foundation.org>
In-Reply-To: <20070216180335.A8744@unix-os.sc.intel.com>
References: <20061211155304.A31760@unix-os.sc.intel.com>
	<20061213224317.GA2986@elte.hu>
	<20061213231316.GA13849@elte.hu>
	<20061213150314.B12795@unix-os.sc.intel.com>
	<20061213233157.GA20470@elte.hu>
	<20061213151926.C12795@unix-os.sc.intel.com>
	<20061219201247.GA12648@elte.hu>
	<20061219131223.E23105@unix-os.sc.intel.com>
	<20070116113505.GA6294@elte.hu>
	<20070130135709.B32010@unix-os.sc.intel.com>
	<20070216180335.A8744@unix-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 18:03:35 -0800
"Siddha, Suresh B" <suresh.b.siddha@intel.com> wrote:

> +	int cpu = smp_processor_id(), idle_at_tick = idle_cpu(cpu);

argh.  Please, do

	int cpu = smp_processor_id();
	int idle_at_tick = idle_cpu(cpu);
