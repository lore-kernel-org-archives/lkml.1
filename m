Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZLVTza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZLVTza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZLVTzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:55:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:53390 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZLVTzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:55:25 -0500
Date: Tue, 22 Dec 2009 20:57:43 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Salman Qazi <sqazi@google.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>
Subject: Re: RFC: A proposal for power capping through forced idle in the
 Linux  Kernel
Message-ID: <20091222205743.4b6cf677@infradead.org>
In-Reply-To: <1261511304.4937.116.camel@laptop>
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
	<20091214161922.6f252492@infradead.org>
	<1261511304.4937.116.camel@laptop>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009 20:48:24 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2009-12-14 at 16:19 -0800, Arjan van de Ven wrote:
> 
> > I like the general idea, I have one request (that I didn't see
> > quite in your explanation): Please make sure that all cpus in the
> > system do their idle injection at the same time, so that memory can
> > go into power saving mode as well during this time etc etc...
> 
> And then you're going to ask that it scales too, right? :-)
> 
> Gang-scheduling is inherently non scalable, be it for idle time or
> not.

well... there's many ways to do this... one option is to agree, ahead
of time, which jiffies values you're going to do the idle thing on.
Say every 100 jiffies where jiffies % 100 is 0....

then the scalability thing isn't a big deal.. and you still do it all
at the same time. Or at least "enough" at the same time for it to not
matter



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
