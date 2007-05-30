Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbXE3IlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbXE3IlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbXE3Ik4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:40:56 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:55198 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbXE3Iky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:40:54 -0400
Date: Wed, 30 May 2007 10:34:39 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andy Whitcroft <apw@shadowen.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
In-Reply-To: <20070529153651.d65fa07c.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.61.0705301033470.11140@yvahk01.tjqt.qr>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <p738xb8fjv2.fsf@bingen.suse.de>
 <465BECCC.5030001@shadowen.org> <Pine.LNX.4.61.0705292218520.11140@yvahk01.tjqt.qr>
 <20070529153651.d65fa07c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 29 2007 15:36, Randy Dunlap wrote:
>> >>> +		if($line=~/^\s*[A-Za-z\d_]+:/ and !($line=~/^\s*default:/)){
>> >>> +			print "Gotos should not be indented\n";
>> >>> +			print "$herecurr";
>> >>> +			$clean = 0;
>> >>> +		}
>> >> 
>> >> emacs generates one space label in front of a goto label. I wouldn't
>> >> outlaw this.
>> >
>> >Yep, we also now allow one space something to do with diff -p not
>> >getting confused...
>> 
>> Not only diff and emacs. At least joe (joe.sf.net) is another editor
[...]
>
>That's just a joe bug then.
>
>diff no longer requires a beginning space, at least in the testing
>that I did it worked with no leading space on a label:.

But not everyone runs the latest and greatest. diffutils 2.8.7
takes /^label:/ as a marker for the @@ line.


	Jan
-- 
