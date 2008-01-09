Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYAIXsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYAIXsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:48:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbYAIXrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:47:52 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:54172 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756013AbYAIXrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:47:51 -0500
Message-ID: <47855D26.30307@oracle.com>
Date: Wed, 09 Jan 2008 15:47:50 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
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
References: <1196983219534-git-send-email-zach.brown@oracle.com> <200801091448.46241.rusty@rustcorp.com.au> <47850F99.5020001@oracle.com> <200801100904.46842.rusty@rustcorp.com.au> <alpine.LFD.1.00.0801091423160.3148@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801091423160.3148@woody.linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 10 Jan 2008, Rusty Russell wrote:
>> I'd have to read his original statement, but eventfd doesn't build up state, 
>> so I think it qualifies.
> 
> How about you guys battle it out by giving an example program usign the 
> interface?
> 
> Here's a favourite really simple load of mine:
> 
>  - do the equivalent of "ls -lR" or "find /usr" as quickly as possible, 
>    without playing "sort by the inode numbers" games (that don't work in 
>    general, but are great for some filesystems)
> 
>    Do this on a directory that isn't newly created, but has had files 
>    added and removed over time (so that the return order of "readdir()" 
>    isn't dense and sorted in the inode tables already). The classic 
>    example is "ls -l /usr/bin" or similar.

Sure, that's straight forward enough.  We've all written little test
apps for variants of this load in the past, anyway.  (It was one of the
first things I did for fibrils, Ingo had a variant for syslets which
read small file data too, Chris has a syslet mode in his 'acp' util, etc.)

I was going to send out a patch series pretty soon which includes
cleanups (I think) of the sys_indirect() infrastructure.  I can throw
together this little test app along with that.

- z
