Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbXI1KrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbXI1KrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 06:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbXI1Kqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 06:46:52 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:29191 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXI1Kqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 06:46:51 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Date: Fri, 28 Sep 2007 12:46:45 +0200
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky> <20070928093902.GA28455@elte.hu> <20070928100024.GB18163@shadowen.org>
In-Reply-To: <20070928100024.GB18163@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281246.45546.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 28. September 2007 schrieb Andy Whitcroft:
> > And this is not about any particular false positive. I dont mind an 
> > "advanced mode" non-default opt-in option for the script, if someone is 
> > interested in borderline or hard to judge warnings too, but these 
> > default false positives are _lethal_ for a tool like this. (and i made 
> > this point before.) This is a _fundamental_ thing, and i'm still not 
> > sure whether you accept and understand that point. This is very basic 
> > and very important, and this isnt the first (or second) time i raised 
> > this.
> 
> You are striving for a level of perfection that is simply not achieveable.

I dont think Ingo is looking for perfection. Its about a different 
optimization goals.

Let me put it this way:

checkpatch in advanced mode:
- I want to be able to see as many possible problems (this is the optimization 
goal)
- I accept that I get false positives
- not useful for git and mail traffic

checkpatch in safe mode:
- I never want a false positive (different optimization goal!)
- I accept that I will miss several real bugs because several tricky tests are 
disabled
- useful for git and mail traffic


Christian
