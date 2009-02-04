Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbZBDFzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbZBDFzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 00:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZBDFzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 00:55:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:49571 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZBDFzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 00:55:44 -0500
Date: Tue, 3 Feb 2009 21:55:52 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Negative values in /proc/latency_stats
Message-ID: <20090203215552.38193470@infradead.org>
In-Reply-To: <20090203214609.39c9c6b2.akpm@linux-foundation.org>
References: <4e5e476b0901310542n796dafbem5c656da07a2f8a56@mail.gmail.com>
	<20090202205545.4e1a32ea.akpm@linux-foundation.org>
	<20090203161648.361a924a@infradead.org>
	<20090203214609.39c9c6b2.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 21:46:09 -0800

> > + * (note: the average latency is the acummulated latency deviced
> > by the number
> > + * of times)
> 
> I was surprised at this.  Is the stack backtracer sufficiently
> reliable/repeatable for this to work?

yep it is, at least on x86 and x86-64.

> 
> > + * Negative latencies (caused by time going backwards) are also
> > explicitly
> > + * skipped.
> 
> Are we sure that this was the cause of the problem?

not 100%, but if you add only positive numbers..... the only other
option is an overflow.. but that would be such a huge latency that that
is not very believable.

> 
> Which time source is the caller using here, and why is it going
> backwards?

scheduler clock.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
