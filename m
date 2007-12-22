Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbXLVADh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbXLVADh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 19:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbXLVADa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 19:03:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720AbXLVAD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 19:03:29 -0500
Message-ID: <476C541C.7090507@redhat.com>
Date: Fri, 21 Dec 2007 19:02:36 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
References: <1197049846.1645.68.camel@localhost.localdomain> <20071211143336.GA17866@elte.hu> <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com> <20071221120908.GA15926@elte.hu> <84144f020712210944q3e0539f8vd8a249f69d456dc7@mail.gmail.com> <Pine.LNX.4.64.0712211412040.3795@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712211435250.3795@schroedinger.engr.sgi.com> <alpine.LFD.0.9999.0712211449320.21557@woody.linux-foundation.org> <20071221231728.GA28008@elte.hu> <Pine.LNX.4.64.0712211552180.27290@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0712211552180.27290@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2007 06:54 PM, Christoph Lameter wrote:
> 
> SLUB: Improve hackbench speed
> 
> Increase the mininum number of partial slabs to keep around and put
> partial slabs to the end of the partial queue so that they can add
> more objects.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 


You forgot to update the commit message.

Should be:


Put partial slabs to the end of the partial queue so that they can add
more objects.
