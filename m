Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbYHSTNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbYHSTNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbYHSTM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:12:56 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39366 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbYHSTMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:12:55 -0400
Message-ID: <48AB1A77.7080501@cs.helsinki.fi>
Date: Tue, 19 Aug 2008 22:09:43 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rdunlap@xenotime.net, mpm@selenic.com,
       tglx@linutronix.de, rostedt@goodmis.org, mathieu.desnoyers@polymtl.ca,
       tzanussi@gmail.com
Subject: Re: [PATCH 3/5] SLUB: Replace __builtin_return_address(0) with	_RET_IP_.
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro> <1219167807-5407-2-git-send-email-eduard.munteanu@linux360.ro> <1219167807-5407-3-git-send-email-eduard.munteanu@linux360.ro> <48AB0D69.4090703@linux-foundation.org> <20080819182423.GA5520@localhost> <48AB1769.3040703@linux-foundation.org> <20080819190506.GC5520@localhost>
In-Reply-To: <20080819190506.GC5520@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard - Gabriel Munteanu wrote:
> On Tue, Aug 19, 2008 at 01:56:41PM -0500, Christoph Lameter wrote:
> 
>> Well maybe this patch will do it then:
>>
>> Subject: slub: Use _RET_IP and use "unsigned long" for kernel text addresses
>>
>> Use _RET_IP_ instead of buildint_return_address() and make slub use unsigned long
>> instead of void * for addresses.
>>
>> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
>>
>> ---
>>  mm/slub.c |   46 +++++++++++++++++++++++-----------------------
>>  1 file changed, 23 insertions(+), 23 deletions(-)
> 
> It seems Pekka just submitted something like this. Though I think using 0L
> should be replaced with 0UL to be fully correct.

Fixed, thanks!

> Pekka, should I test one of these variants and resubmit, or will you
> merge it by yourself?

I'm merging my patch to the kmemtrace branch now.


