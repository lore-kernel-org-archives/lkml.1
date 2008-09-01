Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYIAHU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYIAHU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 03:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYIAHUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 03:20:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54726 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbYIAHUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 03:20:14 -0400
Message-ID: <48BB96E1.8080002@cs.helsinki.fi>
Date: Mon, 01 Sep 2008 10:16:49 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rdunlap@xenotime.net,
       mpm@selenic.com, tglx@linutronix.de, rostedt@goodmis.org,
       cl@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       tzanussi@gmail.com
Subject: Re: [PATCH] kmemtrace: SLUB hooks for caller-tracking functions.
References: <1219600175-5253-1-git-send-email-eduard.munteanu@linux360.ro> <48BAAC3C.4050309@cs.helsinki.fi> <20080831183652.GA5220@localhost>
In-Reply-To: <20080831183652.GA5220@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard - Gabriel Munteanu wrote:
> On Sun, Aug 31, 2008 at 05:35:40PM +0300, Pekka Enberg wrote:
>> Eduard - Gabriel Munteanu wrote:
>>> This patch adds kmemtrace hooks for __kmalloc_track_caller() and
>>> __kmalloc_node_track_caller(). Currently, they set the call site pointer
>>> to the value recieved as a parameter. (This could change if we implement
>>> stack trace exporting in kmemtrace.)
>>> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
>> Applied. I had to do some manual tweaking, so can you please double-check 
>> the result:
>>
>> http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=b9f1ecc6428f0ba391845b2ac7df8618da287e4f
>>
>> Thanks!
> 
> Looks fine to me. However, you can now remove the casts to unsigned long
> from 'caller', i.e. "s/(unsigned long) caller/caller/g"

Fixed, thanks!

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=0fae99540ebb53e0507f2bd6e119bede94e84f77
