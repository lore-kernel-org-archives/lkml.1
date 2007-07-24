Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbXGXSpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbXGXSpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbXGXSp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:45:29 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39973 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbXGXSp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:45:28 -0400
Message-ID: <46A648C5.5050902@austin.ibm.com>
Date: Tue, 24 Jul 2007 13:45:25 -0500
From: jschopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A534EA.6030008@intel.com> <46A5C12B.3080904@shadowen.org> <20070724021526.3d92286b.akpm@linux-foundation.org> <20070724172217.GA10725@linux-sh.org>
In-Reply-To: <20070724172217.GA10725@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>
 > checkpatch has been quite useful
> for catching obviously broken things, and now it seems like it's just
> overreaching. Perhaps this functionality can be split in to a lite
> checkpatch for catching show-stoppers for application and then something
> more akin to a CodingStyle validator for the folks interested in
> arbitrarily defining convention, which they can use freely while the rest
> of us try to get something useful done.

CodingStyle isn't about arbitrarily defining convention.  It is about making the codebase 
consistent, which helps a ton in readability and maintainability.

Readability is important because it makes the job of the maintainers easier.  If you or I 
have to spend 5 minutes to fix trivial CodingStyle issues, but that 5 minutes saves Andrew 
or other maintainers 60 seconds in reviewing your patch, we come out ahead.  Anything that 
shifts work from maintainers to developers is a good thing because maintainers are 
overworked as is.

It could also argue that declaring multiple variables per line or putting curly braces 
where they aren't needed doesn't make code unmaintainable.  I'd agree any one of these 
doesn't make code unmaintainable by itself.  But if all these things are added together it 
is death by 1000 cuts.  The more readable code is the fewer real bugs it will have because 
badness stands out more in clean code.

So, no we shouldn't separate out CodingStyle because

Better CodingStyle == less bugs

and

Better CodingStyle == more throughput for maintainers
