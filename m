Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbYKWUAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbYKWUAO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 15:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYKWT77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:59:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:5339 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbYKWT77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:59:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=dHZqpfKQPilMJnxhow/PRcUFhEoAmnigvNHdYnYOz8iiDW4LRSqmesPPI0AQ4mAvEE
         nzgUZuJlcFsIYPNKbx0LtM+TrELi3m39hT54K1ZMbMNjmHCIgl/0+jUrbrlTvb45XQd1
         KAVctc9ioeQDOBoNOSmMuKrS0fdtWnAc0zO6I=
Date: Sun, 23 Nov 2008 21:59:53 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Subject: Re: [PATCH 1/2] mmiotrace: fix buffer overrun detection
Message-ID: <20081123215953.52da4dca@daedalus.pq.iki.fi>
In-Reply-To: <20081123193413.GB2794@elte.hu>
References: <20081123154148.04e0851a@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0811231134150.27108@gandalf.stny.rr.com>
	<20081123212430.4f6700e9@daedalus.pq.iki.fi>
	<20081123193413.GB2794@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2008 20:34:13 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Pekka Paalanen <pq@iki.fi> wrote:
> 
> > Ingo, could these two patches still make it into .28?
> 
> Sure - applied them to tip/tracing/urgent:
> 
>   fb91ee6: tracing, doc: update mmiotrace documentation
>   7ee1768: x86, mmiotrace: fix buffer overrun detection
> 
> Does this make mmiotrace fully functional in .28 ?

Yes, as fully as it was originally meant to be. Again.
I don't know of any more urgent bugs.

It passes the testmmiotrace.ko test, and also notices overruns if they
happen. Still untested with the nvidia proprietary driver, though, or
with SMP, but it should work.

btw. the testmmiotrace.ko testing cannot be automated, since it
involves writing to "somewhere" in the PCI address space and is
therefore a bit dangerous.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
