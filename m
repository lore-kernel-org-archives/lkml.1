Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbYE3Vti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbYE3Vti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 17:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYE3Vt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 17:49:26 -0400
Received: from mga06.intel.com ([134.134.136.21]:64795 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751198AbYE3Vt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 17:49:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,568,1204531200"; 
   d="scan'208";a="286560570"
Message-ID: <48407667.5040001@linux.intel.com>
Date: Fri, 30 May 2008 14:49:27 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Top kernel oopses/warnings for the week of May 30th 2008
References: <48402DAA.60202@linux.intel.com> <Pine.LNX.4.64.0805302017580.16427@blonde.site> <alpine.LFD.1.10.0805301403540.3141@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805301403540.3141@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 30 May 2008, Hugh Dickins wrote:
>> On Fri, 30 May 2008, Arjan van de Ven wrote:
>>> Rank 7: set_page_address (oops)
>>> 	Reported 53 times (65 total reports)
>>> 	crash coming from flush_all_zero_pkmaps; was this fixed by Hugh the
>>> 	other day?
>> No, not at all.  But I'll have a little ponder over it.
> 
> It's a BUG_ON(), but sadly the oops gatherer doesn't seem to gather that 
> part. You can see it from the code portion: the "<0f> 0b" gives it away 
> (that's the ud2 opcode).

I've seen it a few more times the last few weeks, I'll dig into how that is happening.
Maybe we changed the bug_on text to miss my regexps ;(
(it's only about 1000 lines of perl, so what can go wrong in that ;-)
