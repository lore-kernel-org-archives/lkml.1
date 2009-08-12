Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbZHLQWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbZHLQWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbZHLQWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:22:07 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36645 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293AbZHLQWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:22:06 -0400
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.44L0.0908121005370.2955-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0908121005370.2955-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 11:22:03 -0500
Message-Id: <1250094123.4000.43.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 10:13 -0400, Alan Stern wrote:
> On Wed, 12 Aug 2009, Ingo Molnar wrote:
> 
> > > And here I was thinking kerneldoc doesn't actually work 
> > > like that, but perhaps Randy fixed it so the initial 
> > > description can line-wrap?
> 
> Yes, that's what I thought too.  If kerneldoc has been fixed then the 
> description line certainly should get wrapped.

I really don't think it needs to be fixed: it's a feature not a bug.  It
requires people writing kernel doc actually to think of one line
summaries.

LSI recently tried to submit a ten line wrapped summary which the
current feature makes it very easy to knock back and say this must be a
single line, so trim it and move the rest to the function description
body.

James


