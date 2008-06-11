Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYFKUxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYFKUxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYFKUw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:52:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40224 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbYFKUwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:52:55 -0400
Message-ID: <48503B13.5020508@firstfloor.org>
Date: Wed, 11 Jun 2008 22:52:35 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       clameter@sgi.com, linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, eric.whitney@hp.com,
       Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mm 13/25] Noreclaim LRU Infrastructure
References: <20080606180506.081f686a.akpm@linux-foundation.org> <20080608163413.08d46427@bree.surriel.com> <20080608135704.a4b0dbe1.akpm@linux-foundation.org> <20080608173244.0ac4ad9b@bree.surriel.com> <20080608162208.a2683a6c.akpm@linux-foundation.org> <20080608193420.2a9cc030@bree.surriel.com> <20080608165434.67c87e5c.akpm@linux-foundation.org> <Pine.LNX.4.64.0806101214190.17798@schroedinger.engr.sgi.com> <20080610153702.4019e042@cuia.bos.redhat.com> <20080610143334.c53d7d8a.akpm@linux-foundation.org> <20080611190311.GA30958@shadowen.org>
In-Reply-To: <20080611190311.GA30958@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The problem will come with SPARSEMEM as that stores the section number
> in the reserved field.  Which can mean we need the whole reserve, and
> there is currently no simple way to remove that.

Why do you need that many sections on i386?

-Andi
