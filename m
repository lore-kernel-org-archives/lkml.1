Return-Path: <linux-kernel-owner+w=401wt.eu-S1765465AbXEUXeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765465AbXEUXeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbXEUXeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:34:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46361 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430AbXEUXeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:34:07 -0400
Message-ID: <46522C37.1020404@garzik.org>
Date: Mon, 21 May 2007 19:33:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Tejun Heo <htejun@gmail.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@redhat.com>
Subject: Re: [patch 07/69] libata-sff: Undo bug introduced with pci_iomap
 changes
References: <20070521191612.800400000@sous-sol.org> <20070521191701.791285000@sous-sol.org> <alpine.LFD.0.98.0705211614210.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705211614210.3890@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 21 May 2007, Chris Wright wrote:
>> ---
>> [chrisw: Why is this not upstream yet?]
> 
> And equally importantly, why is it even in the stable queue if it's not 
> upstream.
> 
> It's against stable rules, and it means that we may have stuff that gets 
> fixed in -stable and not in -upstream, if people don't notice. THAT IS 
> BAD!
> 
> Having fixes in stable that don't exist in upstream make -stable be 
> worse than pointless - it means that we actively _lose_ bug-reports. It 
> may sound like a good idea in the short run, but it's a *horrible* thing 
> for the long run.
> 
> IOW, this should not be on the table for -stable, and people involved 
> should have made sure it's in -upstream first!

Strongly agreed.


> And no, I do not think it's languishing in my mailqueue. I'm pretty sure 
> it's languishing somewhere else. 

AFAIK it was obsoleted by another Tejun patch which -is- upstream.

Am I missing something?

	Jeff



