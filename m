Return-Path: <linux-kernel-owner+w=401wt.eu-S1764174AbXF1G5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764174AbXF1G5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 02:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759486AbXF1G5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 02:57:33 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46604 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759451AbXF1G5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 02:57:33 -0400
Message-ID: <46835BD5.8070904@garzik.org>
Date: Thu, 28 Jun 2007 02:57:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, hch@infradead.org,
       johnstul@us.ibm.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com,
       dipankar@in.ibm.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 5/5 v2] Convert tasklets to work queues
References: <20070622182051.859570787@goodmis.org> <20070622182315.571740041@goodmis.org> <20070623095359.4667514e.akpm@linux-foundation.org> <alpine.LFD.0.98.0706231113200.3593@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706231113200.3593@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So do cleanups _separately_ from movement.

Definitely.  Anything else makes review more difficult, by obscuring 
changes with movement.


> Quite frankly, I personally am considering removing "checkpatch.pl". That 
> thing is just a nazi dream. That hard-coded 80-character limit etc is just 
> bad taste. 
> 
> Dammit, code cleanliness is not about "automated and mindless slavish 
> following of rules". A process that is too inflexible is a *bad* process. 
> I'd much rather have a few 80+ character lines than stupid and unreadable 
> line wrapping just because the line hit 87 characters in length.

I don't think checkpatch should be removed, but the 80-column complaint 
is -way- too obnoxious and stupid-simple.

This bugs me like the myriad recent Documentation/CodingStyle proposed 
patches...  It's STYLE dammit.  Sometimes it's best to /not/ lock down 
everything into a rule.  There is such a thing as specifying too much.

	Jeff



