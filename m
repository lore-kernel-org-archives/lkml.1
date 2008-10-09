Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbYJIBSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbYJIBSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 21:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbYJIBSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 21:18:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39221 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbYJIBSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 21:18:46 -0400
Message-ID: <48ED5BC6.8040006@redhat.com>
Date: Wed, 08 Oct 2008 21:17:58 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Ben Hutchings <bhutchings@solarflare.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: [PATCH] documentation: explain memory barriers
References: <20080911101616.GA24064@agk.fab.redhat.com>	<Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>	<20080923154905.50d4b0fa.akpm@linux-foundation.org>	<Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>	<20080923164623.ce82c1c2.akpm@linux-foundation.org>	<Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>	<20081001225404.4e973465.akpm@linux-foundation.org> <20081008181223.6954c7b2.randy.dunlap@oracle.com>
In-Reply-To: <20081008181223.6954c7b2.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Wed, 1 Oct 2008 22:54:04 -0700 Andrew Morton wrote:
> 
>> This sequence is repeated three or four times and should be pulled out
>> into a well-commented function.  That comment should explain the logic
>> behind the use of these barriers, please.
> 
> and on 2008-OCT-08 Ben Hutchings wrote:
> 
>> All memory barriers need a comment to explain why and what they're doing.

Seriously?  When a barrier is used, it's generally self-evident what 
it's doing.  The real problem is when a barrier is *not* used.  It would 
probably be more helpful to comment every non-barrier line of code to 
explain why it's okay if memory operations are getting reordered.

-- Chris
