Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbXLIA3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbXLIA3q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 19:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXLIA3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 19:29:39 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:33385 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbXLIA3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 19:29:38 -0500
Date: Sat, 8 Dec 2007 19:28:36 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Major regression on hackbench with SLUB
In-Reply-To: <alpine.LFD.0.9999.0712071021510.12046@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0712081924150.25994@gandalf.stny.rr.com>
References: <1197049846.1645.68.camel@localhost.localdomain>
 <alpine.LFD.0.9999.0712070957070.7274@woody.linux-foundation.org>
 <alpine.LFD.0.9999.0712071021510.12046@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Due to email problems, I never got your reply on this thread. But I saw
your reply when reading this thread on lkml.org (nor did I receive Linus's
first reply).

Anyway, I booted 2.6.24-rc4-mm1 with the same config, and accepted the
defaults to the new config options as the git version I checked. And it
gave me an average of 12.5 second runs.

Here's the oprofile for it:

http://people.redhat.com/srostedt/slub/results/slub-mm.op

-- Steve



