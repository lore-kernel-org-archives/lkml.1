Return-Path: <linux-kernel-owner+w=401wt.eu-S1762984AbXGJUw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762984AbXGJUw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbXGJUws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:52:48 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46387 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758118AbXGJUwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:52:47 -0400
Date: Tue, 10 Jul 2007 13:52:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: queued spinlock code and results
In-Reply-To: <p733azz16vh.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0707101348020.3055@schroedinger.engr.sgi.com>
References: <20070708043228.GB22397@wotan.suse.de> <p733azz16vh.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007, Andi Kleen wrote:

> I would say the main drawback of switchable and queued locks 
> would be also that they require a larger spinlock_t thus increasing
> cache usage

Right. Zoran Radovic has shown that queued locks are inferior 
to other approaches. The best approach that he found in his research were 
the HBO locks that are somewhat more intelligent form of spinlocks.

http://user.it.uu.se/~zoranr/
http://www.it.uu.se/research/group/uart/projects/nucasynch/

Paper on the issue with measurements:
http://www.it.uu.se/research/publications/lic/2003-008/2003-008.pdf
