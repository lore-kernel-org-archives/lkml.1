Return-Path: <linux-kernel-owner+w=401wt.eu-S1759059AbXIBUnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059AbXIBUnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbXIBUnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:43:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52344 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbXIBUna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:43:30 -0400
Message-ID: <46DB2070.9010608@garzik.org>
Date: Sun, 02 Sep 2007 16:43:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Bottomley <james.bottomley@steeleye.com>,
       Oliver Neukum <oliver@neukum.name>, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mm] DC395x SCSI driver: Shut up uninitialized variable
 build warning
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n> <alpine.LFD.0.999.0709030152260.29617@enigma.security.iitk.ac.in> <46DB1BDF.4090100@garzik.org> <alpine.LFD.0.999.0709030211040.29617@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0709030211040.29617@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> I'll post the info as a reply to the first mail in this series. I have
> fairly recent gcc (4.1.1) and I don't see us dropping support for it in
> the next few years.

What's important is not support lifetime, but whether or not the warning 
persists through version 4.1.2, 4.1.3, etc.

We don't want to add markers for compiler quirks that come and go.

The current markers tend to exist for a class of problems that gcc 
fundamentally has a tough time "seeing."  Different optimizer behaviors 
from compiler version to compiler version are just noise[1].

	Jeff


[1] sometimes quite literally, in the case of compiler warnings.

