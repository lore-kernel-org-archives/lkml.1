Return-Path: <linux-kernel-owner+w=401wt.eu-S1763215AbXGXUdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763215AbXGXUdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041AbXGXUdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:33:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50633 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbXGXUdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:33:07 -0400
Message-ID: <46A661FB.7040504@austin.ibm.com>
Date: Tue, 24 Jul 2007 15:32:59 -0500
From: jschopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andy Whitcroft <apw@shadowen.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A534EA.6030008@intel.com> <46A5C12B.3080904@shadowen.org> <20070724021526.3d92286b.akpm@linux-foundation.org> <20070724172217.GA10725@linux-sh.org> <Pine.LNX.4.64.0707242000120.18990@fbirervta.pbzchgretzou.qr> <46A64587.2010704@shadowen.org> <20070724194901.GE6019@stusta.de>
In-Reply-To: <20070724194901.GE6019@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Yep I think the consensus is we need a
>> "--i-don't-agree-just-check-things-which-will-get-me-rejected-out-of-hand"
>> option of some sort which will restrict output to the real errors.
> 
> No, the default should be to show only the real errors.
> 

CodingStyle violations are real errors.

If we have agreed that code should look a certain way, and there is a patch that doesn't 
look that way, that is an error.  Maybe not a runtime error, but a readability error.  A 
reviewability error.  A maintainability error.  A big waste of everybodies time.

I personally don't care if code is indented with 2 spaces, 4 spaces, or a tab.  What I do 
care about is that all the code is indented consistently so we don't waste an ounce of our 
energy reading code/patches and thinking about indentation or even worse spending our time 
arguing over it on mailing lists when there are better things to argue about.

Back when I wrote the early versions of this script I didn't write it because I'm anal 
retentive about CodingStyle.  I wrote it for the exact opposite reason.  I was tired of 
seeing email on mailing lists reviewing patches saying there was indentation with spaces 
instead of tabs, or trailing whitespace, or { on the wrong line.  It was a waste of the 
reviewers time, it was a waste of the developers time, it was a waste of the time of 
everybody on the mailing lists.  We should spend all that energy arguing over the merits 
of what the code does.

So let's argue over the CodingStyle once and be done with the argument instead of having 
the argument every day on the mailing lists forever.  We end up with more time to argue 
over much more interesting subjects and we end up with consistent code that is easy to 
read, review, and maintain.
