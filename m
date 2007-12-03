Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbXLCWxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbXLCWxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 17:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXLCWxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 17:53:35 -0500
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:41508 "EHLO
	QMTA03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbXLCWxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 17:53:34 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2007 17:53:34 EST
X-Authority-Analysis: v=1.0 c=1 a=YP7E5MQV5OkA:10 a=YgcX7VosQu49YQD9qsUA:9 a=hKDyIZ1KVOtulOTWmRQA:7 a=BGzGSh0UXzL4pj0sUccK2yw4SiwA:4 a=WuK_CZDBSqoA:10
Subject: Re: pnpacpi : exceeded the max number of IO resources
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: yakui.zhao@intel.com, shaohua.li@intel.com, linux-kernel@vger.kernel.org,
       hidave.darkstar@gmail.com, bjorn.helgaas@hp.com, trenn@suse.de,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <475436A3.90906@keyaccess.nl>
References: <1196428488.7066.6.camel@localhost>
	 <47508D3C.9050507@keyaccess.nl>  <475436A3.90906@keyaccess.nl>
Content-Type: text/plain
Date: Mon, 03 Dec 2007 16:51:20 -0600
Message-Id: <1196722280.24704.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-03 at 18:02 +0100, Rene Herman wrote:
> On 30-11-07 23:22, Rene Herman wrote:
> 
> > On 30-11-07 14:14, Chris Holvenstot wrote:
> > 
> >> For what it is worth I too have seen this problem this morning and it
> >> DOES appear to be new (in contrast to a previous comment)
> >>
> >> The message:  pnpacpi: exceeded the max number of mem resources: 12
> >>
> >> is displayed each time the system is booted with the 2.6.24-rc3-git5
> >> kernel but is NOT displayed when booting 2.6.24-rc3-git4
> >>
> >> I have made no changes in my config file between these two kernels other
> >> than to accept any new defaults when running make oldconfig.
> >>
> >> If you had already narrowed it down to a change between git4 and git5 I
> >> apologize for wasting your time.  Have to run to work now.
> > 
> > Thanks, and re-added the proper CCs. Sigh...
> > 
> > Well, yes, the warning is actually new as well. Previously your kernel 
> > just silently ignored 8 more mem resources than it does now it seems.
> > 
> > Given that people are hitting these limits, it might make sense to just 
> > do away with the warning for 2.6.24 again while waiting for the dynamic 
> > code?
> 
> Ping. Should these warnings be reverted for 2.6.24?
> 
> Rene.
> 

Rene - 

Thanks for the follow up - from my perspective now that I know that the
condition that caused the warning messages has been with us for some
time, and that previously the messages were suppressed it really does
not make that much difference to me if the warnings are reverted or not.

So I guess that I vote for doing whatever is best for the developer.
After all they are the ones doing the heavy lifting. If the warning
message is able to provide some insight into the problem so much the
better.

At this point my goal is just to learn enough to be an asset as a tester
instead of a net loss (defined as someone whose efforts cost the team
more man-hours than their contribution is worth)

Chris

