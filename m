Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbZI2ABN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbZI2ABN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZI2ABM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:01:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49423 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZI2ABL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:01:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 29 Sep 2009 08:59:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Wrong Vmalloc numbers in /proc/meminfo
Message-Id: <20090929085905.c7be9d82.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200909281856.08969.elendil@planet.nl>
References: <200909280209.32457.elendil@planet.nl>
	<20090928113222.ae0f49c5.kamezawa.hiroyu@jp.fujitsu.com>
	<200909281856.08969.elendil@planet.nl>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 18:56:08 +0200
Frans Pop <elendil@planet.nl> wrote:

> On Monday 28 September 2009, KAMEZAWA Hiroyuki wrote:
> > > VmallocTotal:   34359738367 kB
> > > VmallocUsed:      340084 kB
> > > VmallocChunk:   34359387131 kB
> > >
> > > Is it me or are VmallocTotal and VmallocChunk off by a factor 10,000
> > > or so?
> >
> > I'm sorry I misunderstand your 10,000 implies.
> 
> What I meant is: is the Vmalloc area really 32 *terra*bytes in size?
> Seems rather big for a system with only 2GB RAM.
> 
VmallocTotal means "available address space size for VMALLOC"
It's fixed size as VMALLOC_END - VMALLOC_START.
VmallocChunk just means "free space in VMALLOC area".
Both of them are not related to size of RAM.

> I'd never noticed it before and it looks strange to me, but I guess it's 
> just the result of having 64-bit addressing: a theoretically addressable 
> area most of which will never actually be used?
> 
you're right. Most of space will never used.

Regards,
-Kame

