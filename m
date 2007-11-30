Return-Path: <linux-kernel-owner+w=401wt.eu-S933833AbXK3BPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833AbXK3BPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 20:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763415AbXK3BPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 20:15:01 -0500
Received: from [222.73.24.84] ([222.73.24.84]:57530 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1763136AbXK3BPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 20:15:00 -0500
Message-ID: <474F6372.70705@cn.fujitsu.com>
Date: Fri, 30 Nov 2007 09:12:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org
Subject: Re: Trailing periods in kernel messages
References: <474E6BD0.20103@cn.fujitsu.com>	<E1IxfE8-0000Sr-9w@faramir.fjphome.nl>	<474E8669.6060409@cn.fujitsu.com>	<200711291120.19595.elendil@planet.nl> <20071129032036.4c021617.akpm@linux-foundation.org>
In-Reply-To: <20071129032036.4c021617.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 29 Nov 2007 11:20:18 +0100 Frans Pop <elendil@planet.nl> wrote:
> 
>> Well, for one it needlessly increases the size of log files.
>> It also IMO just looks weird to have a trailing period only for some 
>> messages and it certainly is completely inappropriate for messages like:
> 
> I'll confess to stealthily deleting some of those periods when nobody is looking.
> I don't find them to have any value and they do have some cost, including screen
> real estate at the source-code level.
> 
> 

Just a roughly grep:

# grep -r -P --include=*.[ch] 'printk.*\.\\n' * | wc -l
6025
# grep -r -P --include=*.[ch] '\.\\n' * | wc -l
12723

:)
