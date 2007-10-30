Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbXJ3Av2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbXJ3Av2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 20:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbXJ3AvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 20:51:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34649 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbXJ3AvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 20:51:19 -0400
Message-ID: <47268000.4000808@garzik.org>
Date: Mon, 29 Oct 2007 20:51:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>, Sam Ravnborg <sam@ravnborg.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>
Subject: Re: [RFC] Create instrumentation directory (git repository)
References: <20071029215138.GA4233@Krystal> <Pine.LNX.4.64.0710291619210.4821@schroedinger.engr.sgi.com> <20071029234012.GB19413@Krystal>
In-Reply-To: <20071029234012.GB19413@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Putting stuff in instrumentation/ by no way means that it becomes
> optional for a subsystem, but merely that it could either export
> information useful for kernel instrumentation or have some
> infrastructure parts merged with others. 

More reason why you should not be moving stuff all around the tree...

Really, file structure is one of the LEAST important issues around -- 
while moving files around introduces a non-zero amount of pain.

New files -- like that godawful and nearly empty samples/ directory -- 
sure, fix that up before release.  But let's not break diffs of existing 
architectures without good reason.

	Jeff


