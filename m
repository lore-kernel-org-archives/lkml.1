Return-Path: <linux-kernel-owner+w=401wt.eu-S935226AbYBBU4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935226AbYBBU4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762482AbYBBU4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:56:13 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:40090 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762268AbYBBU4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:56:11 -0500
Message-ID: <47A4D8E4.8030708@garzik.org>
Date: Sat, 02 Feb 2008 15:56:04 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [patch] pci: pci_enable_device_bars() fix
References: <20080201231147.GA18174@suse.de> <20080202111322.GA30767@elte.hu> <20080202184441.GA12301@suse.de> <20080202190558.GB27927@elte.hu>
In-Reply-To: <20080202190558.GB27927@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Greg KH <gregkh@suse.de> wrote:
> 
>>> ( This call has been introduced upstream 3 weeks ago by commit
>>>   8a4df120b07, but the PCI tree has apparently not been fully 
>>>   re-tested with Linus-latest since that point. )
>> Wait, my testing caught this.  I made the change to the patch myself, 
>> adding the needed conversion to my tree, it's here, on my disk!
>>
>> Oh crap, I never checked it in.
>>
>> /me goes off to sulk in shame.
> 
> you might want to join the (sizable) club of us deeply ashamed people 
> who recently introduced upstream build failures :-/

Personal CC differences aside <grin> I do think you guys both do a good 
job of staying on top of your subsystems.

We all wear the brown paper bag on occasion, and with the "merge 
maelstrom" during each merge window, I'm quite frankly amazed at how 
_little_ stuff get broken overall.

	Jeff



