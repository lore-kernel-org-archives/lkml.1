Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbXJBKJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbXJBKJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 06:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXJBKJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 06:09:08 -0400
Received: from lazybastard.de ([212.112.238.170]:46790 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbXJBKJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 06:09:07 -0400
Date: Tue, 2 Oct 2007 12:04:42 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] printk: add KERN_CONT annotation
Message-ID: <20071002100441.GB5361@lazybastard.org>
References: <20070928105345.GC18163@shadowen.org> <20071001064448.GA4239@elte.hu> <20071001003007.4e90143b.akpm@linux-foundation.org> <20071002043408.GM10199@1wt.eu> <20071002051852.GC28345@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071002051852.GC28345@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 October 2007 07:18:52 +0200, Ingo Molnar wrote:
> 
> ah, this is even nicer than the raw_printk() thing i suggested, and it 
> also nicely documents the intention of the author. Patch attached below.

KERN_CONT was brought up in the linux-tiny discussion.  Not sure if you
want to get involved in that, but there may be value in adding one
variant of KERN_CONT per debug level:
http://lkml.org/lkml/2007/9/30/151

> And i'd like to stress the principle that is followed here: in this 
> particular case the checkpatch.pl warning is very useful, but still 
> there are false positives. Fortunately they are so rare that it's worth 
> annotating those few exceptions in the source. Note that the goal is 
> still to be able to achieve 100% warning-free source code. _That_ should 
> be the driving principle behind checkpatch.pl warnings.

Thank you for working on this.  I had nearly given up on checkpatch
before.

Jörn

-- 
When people work hard for you for a pat on the back, you've got
to give them that pat.
-- Robert Heinlein
