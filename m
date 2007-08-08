Return-Path: <linux-kernel-owner+w=401wt.eu-S935144AbXHHAoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935144AbXHHAoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 20:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758672AbXHHAoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 20:44:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50881 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756977AbXHHAoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 20:44:04 -0400
Message-ID: <46B911C4.8010909@garzik.org>
Date: Tue, 07 Aug 2007 20:43:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Muli Ben-Yehuda <muli@il.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
       riku.seppala@kymp.net, Andy Whitcroft <apw@shadowen.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFT] finish i386 and x86-64 sysdata conversion
References: <46B3A7BB.9000102@redhat.com> <200708041130.42038.ak@suse.de> <20070804093222.f0d7f3c7.akpm@linux-foundation.org> <200708050140.49590.ak@suse.de> <20070805050410.GB4960@rhun.haifa.ibm.com> <86802c440708042238h39fa1b4ude2836fd9732213b@mail.gmail.com> <20070805075307.GA25890@rhun.haifa.ibm.com> <20070807154911.5fe93b40.akpm@linux-foundation.org> <20070807225635.GJ4278@rhun.haifa.ibm.com>
In-Reply-To: <20070807225635.GJ4278@rhun.haifa.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Muli Ben-Yehuda wrote:
> On Tue, Aug 07, 2007 at 03:49:11PM -0700, Andrew Morton wrote:
> 
>> I am sooooooo tired of this thing.  Andi, someone, can we for heaven's
>> sake please just get it all sorted out?
> 
> With regards to the sysdata conversion: Riku says he cannot test new
> kernel. I haven't heard anything from Andy Whitcroft. It passes all of
> my tests and what we have now is obviously broken... I think we should
> put the fix in.

Strongly agreed.  It overall fixes bugs that existing _before_ the 
sysdata stuff went in.

It was clear the NUMA node was /not initialized/ in all cases, and I 
think it's quite unfair to revert the sysdata stuff because of 
pre-existing bugs (that we are fixing right now anyway).

	Jeff



