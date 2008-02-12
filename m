Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbYBLVg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbYBLVg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbYBLVgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:36:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:11540 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbYBLVgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:36:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,341,1199692800"; 
   d="scan'208";a="297968003"
Message-ID: <47B210D3.3000006@linux.intel.com>
Date: Tue, 12 Feb 2008 13:34:11 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       mingo@elte.hu, ak@suse.de, sam@ravnborg.org
Subject: Re: [PATCH 0/8] Create and populate toplevel tests/ for kernel tests
References: <20080211104452.GB7944@in.ibm.com>	<20080212164452.GA31096@infradead.org> <20080212132246.aac67ed1.akpm@linux-foundation.org>
In-Reply-To: <20080212132246.aac67ed1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 12 Feb 2008 11:44:52 -0500
> Christoph Hellwig <hch@infradead.org> wrote:
> 
>> On Mon, Feb 11, 2008 at 04:14:52PM +0530, Ananth N Mavinakayanahalli wrote:
>>> The following series of patches create and populate the toplevel tests/
>>> directory. This will henceforth be the place where all in-kernel tests
>>> live.
>>>
>>> All patches against 2.6.25-rc1 and are just code movement without any
>>> change in functionality.
>> ACK to patches 1-7, and I agree with Ingo that the x86-specific test
>> should stay under arch/x86.
> 
> OK.  But now is basically the worst time for me (or anyone else) to merge
> large code-motion changes like this, because they need to be carried for
> two months or more.
> 

alternatively, since it's just code motion and nothing more, it could just
be done in 2.6.25-rc; in fact doing motion patches in the -rc2 window makes sense to me,
that's the point where all external trees are the smallest, and it should be provably
the same result.. so safe.
