Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbZEKPQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbZEKPQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbZEKPQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:16:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36502 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbZEKPQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:16:11 -0400
Message-ID: <4A0840EF.6020601@redhat.com>
Date: Mon, 11 May 2009 10:14:55 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Josef Bacik <josef@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] fiemap tester
References: <20090508191649.GG9068@unused.rdu.redhat.com> <20090508161318.c73d766c.akpm@linux-foundation.org> <20090511094639.GA7488@infradead.org>
In-Reply-To: <20090511094639.GA7488@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, May 08, 2009 at 04:13:18PM -0700, Andrew Morton wrote:
>> On Fri, 8 May 2009 15:16:49 -0400
>> Josef Bacik <josef@redhat.com> wrote:
>>
>>> Here is small little program which I and Eric have been working on this week to
>>> better test FIEMAP
>> I for one wouldn't complain were someone to create
>> Documentation/fs/tests/ and to then start filling it with stuff.
> 
> Why oh why do people think Documentation/ is a good place for code?
> 
> tests/ would be a much better place :)
> 
> Last time I brought the idea of a small in-tree test harness up at KS
> people weren't too fond of it, but if we get more backing now we could
> try it, otherwise we can just stick it into xfsqa which will hopefully
> soon be generalized to a general fs QA suite.

FWIW, the xfsprogs test suite git tree is currently at 11M; and that's
mostly just for one subtype of one subsystem.  Aiming to have a full
kernel test suite in the kernel tree sounds lke it could get unwieldy to
me...

I'll stick this new test into xfstests regardless, for now...

-Eric
