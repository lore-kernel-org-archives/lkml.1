Return-Path: <linux-kernel-owner+w=401wt.eu-S939381AbXGTRii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939381AbXGTRii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937252AbXGTRiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:38:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:56524 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764254AbXGTRiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:38:01 -0400
Date: Fri, 20 Jul 2007 10:42:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] what should 'uptime' be on suspend?
Message-Id: <20070720104215.476f4cc1.randy.dunlap@oracle.com>
In-Reply-To: <20070720171729.GA19935@deepthought>
References: <46A0210E.6010207@tmr.com>
	<20070720171729.GA19935@deepthought>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 18:17:29 +0100 Ken Moffat wrote:

> On Thu, Jul 19, 2007 at 10:42:22PM -0400, Bill Davidsen wrote:
> > I just found a machine which will resume after suspend to memory, using 
> > the mainline kernel (no suspend2 patch).
> > 
> > On resume I was looking at the uptime output, and it was about six 
> > minutes, FAR longer than the time since resume. So the topic for 
> > discussion is, should the uptime be
> > - time sine the original boot
> > - total uptime since first boot, not counting the time suspended
> > - time since resume
> > - some other time around six minutes
> > 
> > Any of the first three could be useful and "right" for some casesm thus 
> > discussion invited.
> > 
>  My ibook has always been able to suspend to RAM.  For a long while,
> uptime was shown as the time since the last boot.  At some point,
> maybe about a year ago, this was "corrected" to show time since boot
> _less_ time suspended.
> 
>  To be clear, the ibook suspends when I close the lid and resumes
> when I open it.  Uptime used to be convenient, because I could work
> out when I'd last booted.

man uptime:
	uptime - tell how long the system has been running

I claim that the system is not running when it is suspended,
so the suspension time should not be included in uptime.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
