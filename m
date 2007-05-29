Return-Path: <linux-kernel-owner+w=401wt.eu-S1765613AbXE2U1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765613AbXE2U1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbXE2U1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:27:16 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:35704 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbXE2U1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:27:16 -0400
Date: Tue, 29 May 2007 22:22:43 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andy Whitcroft <apw@shadowen.org>
cc: Andi Kleen <andi@firstfloor.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
In-Reply-To: <465BECCC.5030001@shadowen.org>
Message-ID: <Pine.LNX.4.61.0705292218520.11140@yvahk01.tjqt.qr>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <p738xb8fjv2.fsf@bingen.suse.de>
 <465BECCC.5030001@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 29 2007 10:05, Andy Whitcroft wrote:
>
>>> +		if($line=~/^\s*[A-Za-z\d_]+:/ and !($line=~/^\s*default:/)){
>>> +			print "Gotos should not be indented\n";
>>> +			print "$herecurr";
>>> +			$clean = 0;
>>> +		}
>> 
>> emacs generates one space label in front of a goto label. I wouldn't
>> outlaw this.
>
>Yep, we also now allow one space something to do with diff -p not
>getting confused...

Not only diff and emacs. At least joe (joe.sf.net) is another editor
whose %y tag or so also takes lines with

	no space at the front and properly paired parens,braces,etc.

as key lines for %y. Since usually, functions are the only thing at
the beginning of a line, this works well. That's why labels should
be allowed to be indented by one.


	Jan
-- 
