Return-Path: <linux-kernel-owner+w=401wt.eu-S1752366AbZL2BEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbZL2BEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 20:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZL2BEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 20:04:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52539 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbZL2BEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 20:04:07 -0500
Message-ID: <4B39557D.6000600@cn.fujitsu.com>
Date: Tue, 29 Dec 2009 09:03:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ben Blum <bblum@andrew.cmu.edu>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, Paul Menage <menage@google.com>
Subject: Re: [PATCH 2/4] cgroups: subsystem module loading interface
References: <20091221203253.GA5683@andrew.cmu.edu> <20091221203613.GC5683@andrew.cmu.edu> <4B3850F4.4090203@cn.fujitsu.com> <20091228124029.GB4824@andrew.cmu.edu>
In-Reply-To: <20091228124029.GB4824@andrew.cmu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +	write_lock(&css_set_lock);
>>> +	for (i = 0; i < CSS_SET_TABLE_SIZE; i++) {
>>> +		struct css_set *cg;
>>> +		struct hlist_node *node, *tmp;
>>> +		struct hlist_head *bucket = &css_set_table[i], *new_bucket;
>> Please add a blank line between variable declaration and other code.
>>
>> And elsewhere in this patchset.
>>
> 
> checkpatch.pl didn't trip on this [and the more screenspace-intensive
> comment style]; are they cgroups-specific style requirements or from
> somewhere higher up?
> 

You'll find the comment style in Documentation/CodingStyle:

==============
The preferred style for long (multi-line) comments is:

        /*
         * This is the preferred style for multi-line
         * comments in the Linux kernel source code.
         * Please use it consistently.
         *
         * Description:  A column of asterisks on the left side,
         * with beginning and ending almost-blank lines.
         */
==============

Though the other coding style is not documented, I think it's
well accepted.

You'll hardly find code that breaks this style, say in kernel/* and
mm/*. And you can see that people pointed out this when they were
reviewing patches.

And the fact is it does make the code more readable.
