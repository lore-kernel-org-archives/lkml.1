Return-Path: <linux-kernel-owner+w=401wt.eu-S1422737AbXBARNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422737AbXBARNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 12:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422747AbXBARNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 12:13:51 -0500
Received: from rtr.ca ([64.26.128.89]:1654 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422737AbXBARNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 12:13:50 -0500
Message-ID: <45C21FCC.7040406@rtr.ca>
Date: Thu, 01 Feb 2007 12:13:48 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <20070201130234.GA15257@elte.hu> <20070201131903.GA24683@infradead.org> <20070201135215.GA23477@elte.hu>
In-Reply-To: <20070201135215.GA23477@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
> also, we context-switch kernel threads in 350 nsecs on current hardware 
> and the -rt kernel is certainly happy with that and runs all hardirqs 

Ingo, how relevant is that "350 nsecs on current hardware" claim?

I don't mean that in a bad way, but my own experience suggests that
most people doing real hard RT (or tight soft RT) are not doing it
on x86 architectures.  But rather on lowly 1GHz (or less) ARM based
processors and the like.

For RT issues, those are the platforms I care more about,
as those are the ones that get embedded into real-time devices.

??

Cheers
