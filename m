Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbYEAPe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbYEAPe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYEAPeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:34:50 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49964 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYEAPeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:34:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4819E2FD.5070500@s5r6.in-berlin.de>
Date: Thu, 01 May 2008 17:34:21 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Tarkan Erimer <tarkan@netone.net.tr>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net>	<200804302245.50817.rjw@sisk.pl>	<alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org>	<200805010023.32213.rjw@sisk.pl>	<alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org> <20080430154124.7ec08dd4.akpm@linux-foundation.org> <4819B828.1060408@netone.net.tr>
In-Reply-To: <4819B828.1060408@netone.net.tr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tarkan Erimer wrote:
> To improve the quality of kernel releases, maybe we can create a special 
> kernel testing tool.

A variety of bugs cannot be caught by automated tests.  Notably those 
which happen with rare hardware, or due to very specific interaction 
with hardware, or with very special workloads.

An interesting thing to investigate would be to start at the regression 
meta bugs at bugzilla.kernel.org, go through all bugs on which are 
linked from there, and try to figure out
   - if these bugs could have been found by automated or at least
     semiautomatic tests on pre-merge code, and
   - how those tests had to have looked like, e.g. what equipment would
     have been necessary.

Let's look back at the posting at the thread start:
| On Wed, Apr 30, 2008 at 10:03 AM, David Miller <davem@davemloft.net> 
wrote:
| >  Yesterday, I spent the whole day bisecting boot failures
| >  on my system due to the totally untested linux/bitops.h
| >  optimization, which I fully analyzed and debugged.
...
| >  Yet another bootup regression got added within the last 24
| >  hours.

Bootup regressions can be automatically caught if the necessary machines 
are available, and candidate code gets exposure to test parks of those 
machines.  I hear this is already being done, and increasingly so.  But 
those test parks will ever only cover a tiny fraction of existing 
hardware and cannot be subjected to all code iterations and all possible 
.config permutations, hence will have limited coverage of bugs.

And things like the bitops issue depend on review much more than on 
tests, AFAIU.
-- 
Stefan Richter
-=====-==--- -=-= ----=
http://arcgraph.de/sr/
