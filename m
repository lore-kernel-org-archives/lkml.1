Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbZA2DnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbZA2DnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 22:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZA2DnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 22:43:00 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50525 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbZA2Dm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 22:42:59 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [ltt-dev] LTTng 0.87 improved page fault tracing
Cc: kosaki.motohiro@jp.fujitsu.com, ltt-dev@lists.casi.polymtl.ca,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090127210203.GA13478@Krystal>
References: <20090127210203.GA13478@Krystal>
Message-Id: <20090129123827.A959.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 29 Jan 2009 12:42:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

interesting..

> I just combined the 4 page fault handler events that were in the tracing
> hot path of LTTng into 2 :
> 
> kernel page_fault_entry
> kernel page_fault_exit
> 
> They take as parameter the combination of what was available in the
> trap_entry/exit events and handle_mm_fault entry/exit events. This
> should lessen the performance impact of the tracer when it's active.
> I did the related modifications in LTTV 0.12.8.

Just question.

As far as I know, customer has two different requeremtn of the page fault.
  (1) collect number of all page fault
      -> if it is too large, too many interrupt decrease performance.
  (2) collect number of major page fault
      -> major page fault indicate to increase random access I/O,
         then, some customer want to collect major page fault
         (don't include minor page fault)

Is this patch fill (2) requirement?



