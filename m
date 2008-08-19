Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbYHSUTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbYHSUTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYHSUTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:19:15 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56704 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbYHSUTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:19:14 -0400
Message-ID: <48AB2A01.2050500@cs.helsinki.fi>
Date: Tue, 19 Aug 2008 23:16:01 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rdunlap@xenotime.net,
       mpm@selenic.com, tglx@linutronix.de, rostedt@goodmis.org,
       mathieu.desnoyers@polymtl.ca, tzanussi@gmail.com
Subject: Re: [PATCH 3/5] SLUB: Replace __builtin_return_address(0) with	_RET_IP_.
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro> <1219167807-5407-2-git-send-email-eduard.munteanu@linux360.ro> <1219167807-5407-3-git-send-email-eduard.munteanu@linux360.ro> <48AB0D69.4090703@linux-foundation.org> <20080819182423.GA5520@localhost> <48AB1769.3040703@linux-foundation.org> <48AB1A5B.3020305@cs.helsinki.fi> <48AB2A4A.7040103@linux-foundation.org>
In-Reply-To: <48AB2A4A.7040103@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Pekka Enberg wrote:
> 
>> This looks wrong. The '%pS' thingy has a special purpose:
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7daf705f362e349983e92037a198b8821db198af
> 
> True. Just had 10 minutes to do the patch. Can someone stitch all of the good
> things from all three patches together?

I already did that:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=3c0a0d0e24234704387f6356ffc7b47758dc1e05

It's compiled-tested too. I had to do some changes to 
include/linux/slab.h as well.

		Pekka
