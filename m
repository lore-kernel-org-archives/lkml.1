Return-Path: <linux-kernel-owner+w=401wt.eu-S933925AbZINU31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925AbZINU31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933864AbZINU3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:29:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:41317 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933842AbZINU3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:29:24 -0400
Date: Mon, 14 Sep 2009 22:33:03 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com
Subject: Re: [PATCH 7/8] perf: Add a perf record --timechart option
Message-ID: <20090914223303.0e595bb2@infradead.org>
In-Reply-To: <1252915560.5699.35.camel@laptop>
References: <20090912130306.5d0086ea@infradead.org>
	<20090912130645.2765de6d@infradead.org>
	<1252915560.5699.35.camel@laptop>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 10:06:00 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2009-09-12 at 13:06 +0200, Arjan van de Ven wrote:
> > This patch adds a "perf record --timechart" option, to make it easy
> > to capture traces for use by the timechart tool.
> 
> Would it perhaps make sense to make that:
> 
>  perf timechart record

well yes, but it would just be an alias for the former, since it's the
record code that has to do the recording... and that's a rather obscene
layering violation in how perf is set up I think.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
