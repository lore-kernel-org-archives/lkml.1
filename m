Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbXLZVbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbXLZVbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 16:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXLZVbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 16:31:38 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45725 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751533AbXLZVbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 16:31:37 -0500
Date: Wed, 26 Dec 2007 13:31:35 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Theodore Tso <tytso@mit.edu>
cc: Andi Kleen <andi@firstfloor.org>, Willy Tarreau <w@1wt.eu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <20071224233701.GB9784@kernel.org>
Message-ID: <Pine.LNX.4.64.0712261330030.16904@schroedinger.engr.sgi.com>
References: <20071222100326.GF26157@elte.hu>
 <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org>
 <20071222192550.GD28891@thunk.org> <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org>
 <20071222221050.GA20753@1wt.eu> <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com>
 <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org>
 <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com>
 <20071224233701.GB9784@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Dec 2007, Theodore Tso wrote:

> So two questions: why isn't -f the default?  And is /sys/slab

Because it gives misleading output. It displays the name of the first 
of multiple slabs that share the same storage structures.
