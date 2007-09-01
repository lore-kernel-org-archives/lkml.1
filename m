Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbXIAKnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbXIAKnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 06:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbXIAKnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 06:43:33 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46608 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbXIAKnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 06:43:32 -0400
Message-ID: <46D94252.3000505@garzik.org>
Date: Sat, 01 Sep 2007 06:43:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain> <46D89800.8080701@s5r6.in-berlin.de> <Pine.LNX.4.64.0708312109580.7060@localhost.localdomain> <46D92D8E.9020508@s5r6.in-berlin.de>
In-Reply-To: <46D92D8E.9020508@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> But I can state requirements for the 'experimental' marker, from the POV
> of a volunteer driver support guy:
>   - Show it in big letters in the Kconfig prompt of an experimental
>     feature.
>   - Explain at appropriate place(s) what the particular caveats of the
>     feature are.
> That's it.  I am not aware of a need to evaluate this marker in routines
> which calculate the .config, unlike the 'broken' marker.

Correct.


> BTW, the requirements of communication in feature removal processes are
> similar to a degree.  But feature removal involves more active two-way
> communication and is tied to a schedule.

'deprecated' and 'obsolete' are very different beasts from the other 
statuses.  They are largely just a marker of opinion of the developer, 
and are largely treated as synonyms.

Code that was never marked deprecated nor obsolete often appears in 
Documentation/feature-removal-schedule.txt, and eventually gets removed.

Feature deprecation and removal is a very amorphous concept that does 
not fit well at all into Kconfig markers, unlike experimental/broken.

	Jeff


