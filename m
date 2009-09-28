Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbZI1Q4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbZI1Q4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZI1Q4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:56:07 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:52026 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407AbZI1Q4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:56:07 -0400
From: Frans Pop <elendil@planet.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: Wrong Vmalloc numbers in /proc/meminfo
Date: Mon, 28 Sep 2009 18:56:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200909280209.32457.elendil@planet.nl> <20090928113222.ae0f49c5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090928113222.ae0f49c5.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909281856.08969.elendil@planet.nl>
X-OriginalArrivalTime: 28 Sep 2009 16:56:08.0996 (UTC) FILETIME=[938A3E40:01CA405C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 September 2009, KAMEZAWA Hiroyuki wrote:
> > VmallocTotal:   34359738367 kB
> > VmallocUsed:      340084 kB
> > VmallocChunk:   34359387131 kB
> >
> > Is it me or are VmallocTotal and VmallocChunk off by a factor 10,000
> > or so?
>
> I'm sorry I misunderstand your 10,000 implies.

What I meant is: is the Vmalloc area really 32 *terra*bytes in size?
Seems rather big for a system with only 2GB RAM.

I'd never noticed it before and it looks strange to me, but I guess it's 
just the result of having 64-bit addressing: a theoretically addressable 
area most of which will never actually be used?
