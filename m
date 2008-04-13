Return-Path: <linux-kernel-owner+w=401wt.eu-S1759452AbYDMQ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452AbYDMQ5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 12:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbYDMQ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 12:57:12 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:15326 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYDMQ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 12:57:11 -0400
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 2/2] bootmem: Node-setup agnostic free_bootmem()
From: Andi Kleen <andi@firstfloor.org>
References: <20080412223319.372887160@symbol.fehenstaub.lan>
	<20080412225850.704752615@symbol.fehenstaub.lan>
Date: Sun, 13 Apr 2008 18:56:57 +0200
In-Reply-To: <20080412225850.704752615@symbol.fehenstaub.lan> (Johannes Weiner's message of "Sun, 13 Apr 2008 00:33:21 +0200")
Message-ID: <87lk3hwv52.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Apr 2008 16:50:12.0700 (UTC) FILETIME=[70FF09C0:01C89D86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@saeurebad.de> writes:

> Make free_bootmem() look up the node holding the specified address
> range which lets it work transparently on single-node and multi-node
> configurations.

Acked-by: Andi Kleen <andi@firstfloor.org>

This is far better than the original change it replaces and which 
I also objected to in review.

-Andi
