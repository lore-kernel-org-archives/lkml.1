Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbZEDWP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbZEDWP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbZEDWPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:15:17 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53799 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbZEDWPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:15:16 -0400
Message-ID: <49FF68EF.40300@linux.vnet.ibm.com>
Date: Mon, 04 May 2009 15:15:11 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: perf_counter: resetting a event counter
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In implementing the PAPI_reset function, whose purpose is to reset all 
of the counters in an event set, I found that [it appears] there is no 
straight-forward way to implement this function using "Performance 
Couunters for Linux".  My current implementation just closes the 
counters and reopens them again.  This is not a elegant solution, nor is 
the other alternative that occurred to me: maintain a "virtual" counter 
in user space, maintained using a base count, which is subtracted off of 
the current perf_counter value of a particular counter.

Is there a way that I missed to reset an event counter?  If not, I'd 
like to request that a new ioctl command be added to support this ability.

Thanks for your consideration,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

