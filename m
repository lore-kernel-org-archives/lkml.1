Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbXE2Weh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbXE2Weh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbXE2WeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:34:25 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:23061 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbXE2WeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:34:23 -0400
Date: Tue, 29 May 2007 15:36:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Andy Whitcroft <apw@shadowen.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
Message-Id: <20070529153651.d65fa07c.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.61.0705292218520.11140@yvahk01.tjqt.qr>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky>
	<p738xb8fjv2.fsf@bingen.suse.de>
	<465BECCC.5030001@shadowen.org>
	<Pine.LNX.4.61.0705292218520.11140@yvahk01.tjqt.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 22:22:43 +0200 (MEST) Jan Engelhardt wrote:

> 
> On May 29 2007 10:05, Andy Whitcroft wrote:
> >
> >>> +		if($line=~/^\s*[A-Za-z\d_]+:/ and !($line=~/^\s*default:/)){
> >>> +			print "Gotos should not be indented\n";
> >>> +			print "$herecurr";
> >>> +			$clean = 0;
> >>> +		}
> >> 
> >> emacs generates one space label in front of a goto label. I wouldn't
> >> outlaw this.
> >
> >Yep, we also now allow one space something to do with diff -p not
> >getting confused...
> 
> Not only diff and emacs. At least joe (joe.sf.net) is another editor
> whose %y tag or so also takes lines with
> 
> 	no space at the front and properly paired parens,braces,etc.
> 
> as key lines for %y. Since usually, functions are the only thing at
> the beginning of a line, this works well. That's why labels should
> be allowed to be indented by one.

That's just a joe bug then.

diff no longer requires a beginning space, at least in the testing
that I did it worked with no leading space on a label:.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
