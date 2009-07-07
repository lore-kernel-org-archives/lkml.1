Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbZGGQxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbZGGQxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758308AbZGGQxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:53:25 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:56177 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758545AbZGGQxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:53:23 -0400
Date: Tue, 7 Jul 2009 12:53:17 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Minchan Kim <minchan.kim@gmail.com>
cc: Wu Fengguang <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 5/5] add NR_ANON_PAGES to OOM log
In-Reply-To: <28c262360907050827y577c3859g5e05e82935e96010@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0907071252060.5124@gentwo.org>
References: <20090705182533.0902.A69D9226@jp.fujitsu.com>  <20090705121308.GC5252@localhost>  <20090705211739.091D.A69D9226@jp.fujitsu.com>  <20090705130200.GA6585@localhost>  <2f11576a0907050619t5dea33cfwc46344600c2b17b5@mail.gmail.com> 
 <28c262360907050804p70bc293uc7330a6d968c0486@mail.gmail.com>  <20090705151628.GA11307@localhost> <28c262360907050827y577c3859g5e05e82935e96010@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009, Minchan Kim wrote:

> Anyway, I think it's not a big cost in normal system.
> So If you want to add new accounting, I don't have any objection. :)

Lets keep the counters to a mininum. If we can calculate the values from
something else then there is no justification for a new counter.

A new counter increases the size of the per cpu structures that exist for
each zone and each cpu. 1 byte gets multiplies by the number of cpus and
that gets multiplied by the number of zones.

