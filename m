Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbXEIMHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbXEIMHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbXEIMHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:07:06 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:33481 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbXEIMHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:07:05 -0400
Message-ID: <4641B92D.1030909@s5r6.in-berlin.de>
Date: Wed, 09 May 2007 14:06:05 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org, rjw@sisk.pl,
       James.Bottomley@SteelEye.com, aneesh.kumar@gmail.com, drzeus@drzeus.cx,
       dwmw2@infradead.org, ego@in.ibm.com, greg@kroah.com, mingo@elte.hu,
       neilb@suse.de, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com,
       vatsa@in.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 128/197] freezer: add try_to_freeze calls to all kernel
 threads
References: <200705090934.l499YTvX019783@shell0.pdx.osdl.net> <4641A5F1.5080901@s5r6.in-berlin.de> <20070509104949.GA8164@elf.ucw.cz>
In-Reply-To: <20070509104949.GA8164@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> > Add try_to_freeze() calls to the remaining kernel threads that do not call
>> > try_to_freeze() already, although they set PF_NOFREEZE.
>> > 
>> > In the future we are going to replace PF_NOFREEZE with a set of flags that
>> > will be set to indicate in which situations the task should not be frozen (for
>> > example, there can be a task that should be frozen for the CPU hotplugging and
>> > should not be frozen for the system suspend).
[...]
>> Why add no-op-try_to_freeze() everywhere now, instead of adding it later
>> when it will actually be needed?  (I.e. "in the future".)
> 
> It is needed later in the patch series... for kprobes, etc.

So does freezer_exempt() still do what its name says, or does it
freezer_exempt_but_not_always() now?
-- 
Stefan Richter
-=====-=-=== -=-= -=--=
http://arcgraph.de/sr/
