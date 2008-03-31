Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbYCaT33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbYCaT33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 15:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYCaT3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 15:29:21 -0400
Received: from rtr.ca ([76.10.145.34]:1447 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbYCaT3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 15:29:21 -0400
Message-ID: <47F13B8F.1000003@rtr.ca>
Date: Mon, 31 Mar 2008 15:29:19 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Tino Keitel <tino.keitel@gmx.de>
Subject: Re: 2.6.25-rc6-git6: Reported regressions from 2.6.24
References: <200803220259.48534.rjw@sisk.pl> <alpine.LFD.1.00.0803311118120.14670@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803311118120.14670@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 22 Mar 2008, Rafael J. Wysocki wrote:
> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10291
>> Subject		: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini Core Duo
>> Submitter	: Tino Keitel <tino.keitel@gmx.de>
>> Date		: 2008-03-20 07:05 (2 days old)
>> References	: http://lkml.org/lkml/2008/3/20/23
> 
> Hmm. I just tested mine, and it still works fine (current -git, 
> obviously). But as usual, I tend to run different kernel configs than most 
> people (no modules, only drivers that are actually useful). So I think 
> this needs bisecting or something.
..

I wonder if this is related to the USB suspend/resume bug I see here?

One way to tell, is to rebuild the kernel with CONFIG_USB_SUSPEND=n.
If suspend/resume then works, we might well be looking at the same bug.

-ml
