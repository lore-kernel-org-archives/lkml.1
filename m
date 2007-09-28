Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbXI1Puq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbXI1Puq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 11:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760247AbXI1Pug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 11:50:36 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51158 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760155AbXI1Puf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 11:50:35 -0400
Message-ID: <46FD22B7.2030402@austin.ibm.com>
Date: Fri, 28 Sep 2007 10:50:15 -0500
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky> <20070928084003.GA18882@elte.hu> <20070928020132.f6c6f528.akpm@linux-foundation.org> <20070928092235.GA31180@shadowen.org> <20070928093902.GA28455@elte.hu> <20070928100024.GB18163@shadowen.org> <20070928104935.GA606@elte.hu> <20070928132138.GG18163@shadowen.org>
In-Reply-To: <20070928132138.GG18163@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The only question is whether this should default to on.  You are voting
> off.  I personally think on.
> 
> Andrew?  Randy?  Joel?

The main audience of this is new contributors, who should have more verbose 
output, including nitpicky things like multiple assignments per line.  The 
default should target them.  More advanced users can certainly use a flag 
that says "give me only the real errors".

It might be a good idea to have three levels.
--really-errors
--really-picky
--really-experimental

Only with better names.  --really-picky would be default, but would only 
include tests that have a very very high ratio of hits to false positives, 
but would still call out things like multiple assignments per line. 
--really-errors we could call the Igno level.  --really-experimental would 
call out all issues, even on checks that generate a fair number of false 
positives.

-Joel

