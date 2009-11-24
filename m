Return-Path: <linux-kernel-owner+w=401wt.eu-S933887AbZKXSdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887AbZKXSdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933788AbZKXSdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:33:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52728 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933769AbZKXSdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:33:02 -0500
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dimitri Sivanich <sivanich@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4B0C259A.5020303@kernel.org>
References: <20091120211139.GB19106@sgi.com>
	 <m1r5rrr9v5.fsf@fess.ebiederm.org> <20091122011457.GA16910@sgi.com>
	 <alpine.LFD.2.00.0911241246470.24119@localhost.localdomain>
	 <1259069986.4531.1453.camel@laptop>
	 <alpine.LFD.2.00.0911241443110.24119@localhost.localdomain>
	 <20091124065022.6933be1a@infradead.org> <m1ws1f6csh.fsf@fess.ebiederm.org>
	 <20091124182059.GB11894@elte.hu>  <4B0C259A.5020303@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 19:32:43 +0100
Message-ID: <1259087563.4531.1776.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 10:27 -0800, Yinghai Lu wrote:

> we already have dev numa node, so could just make irqblance to some smart to use
> that device node corresponding for irq that is binding to the device.

The argument is that a single device can have multiple IRQs and
therefore numa nodes.

