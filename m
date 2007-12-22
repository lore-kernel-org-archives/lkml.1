Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbXLVAfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbXLVAfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 19:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbXLVAfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 19:35:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbXLVAfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 19:35:07 -0500
Message-ID: <476C5B66.9030209@redhat.com>
Date: Fri, 21 Dec 2007 19:33:42 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
References: <20071211143336.GA17866@elte.hu>	<Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>	<Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>	<20071221120908.GA15926@elte.hu>	<Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com>	<alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org>	<Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com>	<1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy>	<Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>	<20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de>
In-Reply-To: <p731w9ffu8c.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2007 07:28 PM, Andi Kleen wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> 
>> Christoph, /proc/slabinfo is an _ABI_. You HAVE to provide it. slabtop 
>> relies on it, people use it every day to monitor memory consumption.
> 
> It's definitely not a stable ABI. slabtop tends to exit without any
> error message on any slabinfo version number increase and I've seen
> that happen several times in not so old kernels.
> 
> Requiring just another slabtop update isn't really a big deal.
> 
> Also it's not that it's a critical functionality like udev.
> 

There's also Documentation/vm/slabinfo.c, which really belongs in
some kind of 'kernel utilities' package. Since it's so intimately
tied to kernel version I don't think it belongs in util-linux.

