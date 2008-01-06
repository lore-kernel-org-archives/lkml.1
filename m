Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYAFDe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYAFDe7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 22:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYAFDes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 22:34:48 -0500
Received: from mga07.intel.com ([143.182.124.22]:39282 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751502AbYAFDer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:34:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,249,1196668800"; 
   d="scan'208";a="359337172"
Message-ID: <47804B91.1050709@linux.intel.com>
Date: Sat, 05 Jan 2008 19:31:29 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: Top 10 kernel oopses for the week ending January 5th, 2008
References: <477FF149.4070609@linux.intel.com> <p733atbr5q4.fsf@bingen.suse.de>
In-Reply-To: <p733atbr5q4.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Arjan van de Ven <arjan@linux.intel.com> writes:
>> Rank 4: remove_proc_entry
>> 	Was also ranked 4th last week
>> 	Only in tainted oopses
>> 	Reported 3 times (12 total reports)
>> 	More info: http://www.kerneloops.org/search.php?search=remove_proc_entry
> 
> Likely a broken module_exit() function that corrupts the list. To track
> these down it might be useful to keep a list of recently unloaded modules
> and dump these too in the oops module list with a special flag.
> 
I suspect that simply printing the currently unloading module will catch 90%+ already;
I'll look into adding this, it's a very good idea.
