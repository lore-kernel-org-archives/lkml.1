Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbXLUW1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbXLUW1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbXLUW1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:27:11 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53947 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753254AbXLUW1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:27:10 -0500
Date: Fri, 21 Dec 2007 14:27:09 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <1198275453.30889.4.camel@lappy>
Message-ID: <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
References: <1197049846.1645.68.camel@localhost.localdomain> 
 <20071211143336.GA17866@elte.hu>  <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
  <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com> 
 <20071221120908.GA15926@elte.hu>  <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com>
  <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com> 
 <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007, Peter Zijlstra wrote:

> BTW, does /proc/slabinfo exist again? I thought we set that as a
> requirement for SLUB to be the default and a full replacement for SLAB.

Well the information that would be exposed in /proc/slabinfo would only be 
faked up stuff from SLUB. The queues that are described in /proc/slabinfo do not 
exist f.e. (tunables do not make sense) and there are more details available via /sys/kernel/slab.

There is a discussion on linux-mm with some of the people working on tools 
to make these to use the information that SLUB provides.



