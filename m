Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbYI3Igt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbYI3Igt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYI3Igm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:36:42 -0400
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:54699 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbYI3Igl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:36:41 -0400
From: Frans Pop <elendil@planet.nl>
To: venkatesh.pallipadi@intel.com
Subject: Re: [patch 2/2] x86: Handle error returns in set_memory_*
Date: Tue, 30 Sep 2008 10:36:04 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, arjan@linux.intel.com, tglx@linutronix.de,
       hpa@zytor.com, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
References: <20080913000003.732756000@linux-os.sc.intel.com> <20080913000051.970641000@linux-os.sc.intel.com> <20080913000051.970641000@linux-os.sc.intel.com> <20080914141012.GA17727@elte.hu>
In-reply-To: <20080914141012.GA17727@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809301036.05207.elendil@planet.nl>
X-OriginalArrivalTime: 30 Sep 2008 08:36:05.0787 (UTC) FILETIME=[94489EB0:01C922D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>> Correctly handle the error returns from set_memory_*. We have to free
>> memtype on error return path.
> 
> we should emit a kernel warning as well if any of those calls fail.
> Drivers should not be randomly poking on RAM ranges.

Has this comment from Ingo been addressed already?
 
> i'm also missing some background on this, could you please explain in a
> bit more detail about what errors there were triggered, and how they
> caused the display artifacts?

I would be interested in this as well.

As I mentioned before, I only tested with the first of the two patches  
(as you asked me to) and that solved the artifacts for me. What's the 
explanation behind that?

What is the relationship between the first and second patch?

Cheers,
FJP
