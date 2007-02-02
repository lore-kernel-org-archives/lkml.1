Return-Path: <linux-kernel-owner+w=401wt.eu-S1423040AbXBBMWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423040AbXBBMWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 07:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423046AbXBBMWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 07:22:39 -0500
Received: from ns1.suse.de ([195.135.220.2]:34430 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423040AbXBBMWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 07:22:38 -0500
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	<df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net>
	<20070201083611.GC18233@elte.hu> <20070201130234.GA15257@elte.hu>
	<20070201131903.GA24683@infradead.org>
From: Andi Kleen <ak@suse.de>
Date: 02 Feb 2007 14:23:04 +0100
In-Reply-To: <20070201131903.GA24683@infradead.org>
Message-ID: <p7364akofrb.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:
> 
> I tend to agree.  Note that there is one thing we should be doing one
> one day (not only if we want to use it for aio) is to make kernel threads
> more lightweight.  Thereéis a lot of baggae we keep around in task_struct
> and co that only makes sense for threads that have a user space part and
> aren't or shouldn't be needed for a purely kernel-resistant thread.

I suspect you will get a lot of this for free from the current namespace
efforts.

-Andi
