Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZD0IRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZD0IRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZD0IRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:17:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:57982 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbZD0IRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:17:25 -0400
Subject: Re: [BUG] 2.6.30-rc3: BUG triggered on some hugepage usages
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20090424095116.GB14283@csn.ul.ie>
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain>
	 <20090424095116.GB14283@csn.ul.ie>
Content-Type: text/plain
Date: Mon, 27 Apr 2009 18:15:38 +1000
Message-Id: <1240820138.7169.10.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-24 at 10:51 +0100, Mel Gorman wrote:
> I'm seeing some tests with sysbench+postgres+large pages fail on ppc64
> although a very clear pattern is not forming as to what exactly is
> causing it. However, the libhugetlbfs regression tests (make && make
> func) are triggering the following oops when calling mlock() and so
> are
> likely related.

This would be a spurrious WARN_ON().. the test I added in there should
not apply to huge pages. However, I don't see that causing a functional
problem with sysbench+postgres

Ben.


