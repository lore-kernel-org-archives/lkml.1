Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbYHUK6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbYHUK6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYHUK6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:58:38 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:36620 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbYHUK6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:58:37 -0400
Message-ID: <48AD4A0B.8020805@s5r6.in-berlin.de>
Date: Thu, 21 Aug 2008 12:57:15 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 2.6.27-rc4	released
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com> <1219313231.8651.101.camel@twins>
In-Reply-To: <1219313231.8651.101.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2008-08-20 at 20:50 -0600, jmerkey@wolfmountaingroup.com wrote:
> 
>>  volatiles left in the code due to the previously stated
>>  (and still present) severe breakage of the GNU compiler with SMP 
>>  shared data.  most of the barrier() functions are just plain broken
>>  and do not result in proper compiler behavior in this tree. 
> 
> Can you provide explicit detail?
> 
> By using barrier() the compiler should clobber all its memory and
> registers therefore forcing a write/reload of the variable.

I hope Jeff didn't try mere barrier()s only.  smp_wmb() and smp_rmb()
are the more relevant barrier variants for mdb, from what I remember
when I last looked at it.
-- 
Stefan Richter
-=====-==--- =--- =-=-=
http://arcgraph.de/sr/
