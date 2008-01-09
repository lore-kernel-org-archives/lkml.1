Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYAIXPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYAIXPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYAIXPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:15:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58078 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbYAIXPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:15:38 -0500
Date: Wed, 9 Jan 2008 15:05:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
Subject: Re: [PATCH 5/6] syslets: add generic syslets infrastructure
In-Reply-To: <alpine.LFD.1.00.0801091423160.3148@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0801091502570.3148@woody.linux-foundation.org>
References: <1196983219534-git-send-email-zach.brown@oracle.com> <200801091448.46241.rusty@rustcorp.com.au> <47850F99.5020001@oracle.com> <200801100904.46842.rusty@rustcorp.com.au> <alpine.LFD.1.00.0801091423160.3148@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jan 2008, Linus Torvalds wrote:
> 
> Try this with and without a "echo 3 > /proc/sys/vm/drop_caches" in 
> between. Both are real and relevant usage cases, I think.

Side note, for me the difference on my home directory for the cached vs 
uncached case is 5 seconds vs 5 minutes. I like the 5 sec, I'd like to 
improve on that 5 min.

Is this test a bit *too* simplistic? Probably. But I think that if we can 
come up with an interface that works ok for that test, it at least signals 
*something*.

			Linus
