Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbXFWTF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbXFWTF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 15:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbXFWTFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 15:05:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35021 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752341AbXFWTFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 15:05:17 -0400
Date: Sat, 23 Jun 2007 11:58:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, hch@infradead.org,
       johnstul@us.ibm.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com,
       dipankar@in.ibm.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 5/5 v2] Convert tasklets to work queues
Message-Id: <20070623115842.e3cfbc41.akpm@linux-foundation.org>
In-Reply-To: <20070623115252.fc36f20c.rdunlap@xenotime.net>
References: <20070622182051.859570787@goodmis.org>
	<20070622182315.571740041@goodmis.org>
	<20070623095359.4667514e.akpm@linux-foundation.org>
	<alpine.LFD.0.98.0706231113200.3593@woody.linux-foundation.org>
	<20070623115252.fc36f20c.rdunlap@xenotime.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 11:52:52 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:

> > Quite frankly, I personally am considering removing "checkpatch.pl". That 
> > thing is just a nazi dream. That hard-coded 80-character limit etc is just 
> > bad taste.
> 
> Who wrote that part of CodingStyle?
> 
> 
> The script is certainly no substitute for personal review.
> And it's certainly not the final say on anything.
> (neither is CodingStyle AFAIK)
> It's just a helper for Andrew.

people are free to disagree with it - it's more of a "hey,
did you really mean to do this" thing.

It might need some fine-tuning..
