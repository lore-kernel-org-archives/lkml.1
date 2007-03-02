Return-Path: <linux-kernel-owner+w=401wt.eu-S1030501AbXCBWAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030501AbXCBWAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030502AbXCBWAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:00:08 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:42400 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030501AbXCBWAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:00:05 -0500
Date: Fri, 2 Mar 2007 13:58:34 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Adam Litke <agl@us.ibm.com>
Cc: Bill Irwin <bill.irwin@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org
Subject: Re: Kernel Oops with shm namespace cleanups
Message-ID: <20070302215834.GM10643@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Adam Litke <agl@us.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	akpm@linux-foundation.org
References: <1172693610.12805.16.camel@localhost.localdomain> <20070302000808.GE10643@holomorphy.com> <1172852957.12220.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172852957.12220.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 16:08 -0800, Bill Irwin wrote:
>> Looks like I should grab these testcases for the sake of due diligence
>> (not to say I intend to alter maintenance style from primarily review,
>> approval, and bugfixing, not that I've been doing as much of any of those
>> as I should). To which architectures and/or distributions have the
>> userspace bits been ported, or otherwise run/tested on? A quick sniff
>> test on an Altix suggests SLES and/or ia64 may trip up the scripts:

On Fri, Mar 02, 2007 at 10:29:16AM -0600, Adam Litke wrote:
> Right now we support x86, powerpc, and x86_64.  Segment remapping and
> hugetlb malloc won't work on ia64 until long format vhpt is supported (I
> suspect).  But the test framework should be adaptable to other
> architectures.

Those patches have been around for a while. I'll ping Tony Luck et al
about that since I'm not entirely aware of what their issues might be.
I should probably get some testing in on sparc64 at some point, too.


-- wli
