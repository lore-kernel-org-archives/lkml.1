Return-Path: <linux-kernel-owner+w=401wt.eu-S1030463AbXDJIRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030463AbXDJIRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030474AbXDJIRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:17:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33597 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030463AbXDJIRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:17:17 -0400
Message-ID: <461B47F5.6080804@garzik.org>
Date: Tue, 10 Apr 2007 04:16:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, Robin Holt <holt@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <4616CBF0.7090606@garzik.org> <20070409172339.48d661d6.akpm@linux-foundation.org> <20070410015912.GE1994@redhat.com> <20070409193056.6b52c354.akpm@linux-foundation.org> <20070410074422.GA30507@flint.arm.linux.org.uk>
In-Reply-To: <20070410074422.GA30507@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> Could probably be eliminated if we had some mechanism to spawn a helper
> thread to do some task as required which didn't block other helper
> threads until it completes.

kthread_run() should go that for you.  Creates a new thread with 
kthread_create(), and wakes it up immediately.  Goes away when you're 
done with it.

	Jeff


