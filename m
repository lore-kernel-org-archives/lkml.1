Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbZE1TwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbZE1TwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 15:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbZE1TwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 15:52:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44351 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbZE1TwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 15:52:14 -0400
Message-ID: <4A1EEB45.5010404@garzik.org>
Date: Thu, 28 May 2009 15:51:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 17/17] xen: disable MSI
References: <1243409850-21577-1-git-send-email-jeremy@goop.org> <1243409850-21577-18-git-send-email-jeremy@goop.org> <alpine.LFD.2.01.0905270829530.3435@localhost.localdomain> <20090527211828.GA6166@elte.hu> <alpine.LFD.2.01.0905271436140.3435@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0905271436140.3435@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 27 May 2009, Ingo Molnar wrote:
>> hm, i have to concur. Too often it ends up splitting attention away 
>> from the title of the commit. I do reject (or fix up) bad impact 
>> lines - will stop doing them altogether if you think there's a net 
>> downside to them ...
> 
> I actually think that if there is a good reason for them, they can stay. 
> 
> Just don't make it one of those "every commit that goes through me has to 
> have one".
> 
> Pu another way: if they actually add value in highlighting the commits 
> that _should_ stand out, then hey, by all means, keep such ones. I would 
> not at all object if it was an issue of 
> 
>  [ Impact: fix bugzilla entry 455123 ]
> 
> or
> 
>  [ Impact: fix user-triggerable oops ]

Ideally "Impact" is pointless if you are otherwise writing a clear, 
concise commit description.  "Fixes user-triggerable oops" on a line by 
itself is clear enough, and is how I've been writing descriptions for a 
while.

People with the urge to add "Impact:" to every commit wind up either 
being redundant, or for small patches, having the entire ex-Subject 
commit description be "Impact: blah blah blah"

If IOW, if the impact is not already clear, you're doing something 
wrong, and "Impact" is not necessarily going to fix that.

	Jeff



