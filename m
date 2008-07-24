Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbYGXGj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbYGXGj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 02:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbYGXGjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 02:39:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:56774 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYGXGjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 02:39:21 -0400
Subject: Re: Odd swapping issue
From: Peter Zijlstra <peterz@infradead.org>
To: David Newall <davidn@davidnewall.com>
Cc: Rafal Wijata <devnull@wijata.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4887A000.30605@davidnewall.com>
References: <488761F0.4040906@wijata.com> <1216835428.7257.194.camel@twins>
	 <4887A000.30605@davidnewall.com>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 08:39:25 +0200
Message-Id: <1216881565.7257.212.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 06:47 +0930, David Newall wrote:
> Peter Zijlstra wrote:
> > 16g ram on a 32bit kernel is stretching it... may I suggest running a
> > 64bit kernel?
> >   
> 
> Is it?  Do we expect that behaviour with so much RAM?

I expect your 32bit machine to go wonky after say 8gb,.. maybe even
earlier for some workloads.

The thing is, 32bit machines have less than 1gb of kernel memory - the
more memory you have the less of that remains for system duties since
such things as the page frame array grow with the number of physical
pages present.

Also, all such things as buffer cache reside in that tiny space. At some
point the kernel itself is just going to run out of memory trying to
manage your machine.



