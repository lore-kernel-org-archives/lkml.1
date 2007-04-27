Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbXD0QPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbXD0QPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbXD0QPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:15:45 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:26586 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049AbXD0QPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:15:30 -0400
Subject: Re: [patch 18/38] Improved oops output.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <46321E5E.9010909@redhat.com>
References: <20070427140503.087958775@de.ibm.com>
	 <20070427140516.013904506@de.ibm.com>
	 <20070427142506.GA12738@infradead.org> <1177687465.23773.2.camel@localhost>
	  <46321E5E.9010909@redhat.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 27 Apr 2007 18:15:48 +0200
Message-Id: <1177690548.23773.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 12:01 -0400, Chuck Ebbert wrote:
> Martin Schwidefsky wrote:
> >> So we're growing in-kernel disassemblers now? :)
> >>
> >> I wonder whether this is really worth it, but at least your handwritten
> >> one is much nicer than the copy & paste from gdb in the kdb patches.
> > 
> > The disassembler uses about 8K of memory and it really helps in
> > debugging. For me it is worth the cost.
> > 
> 
> No ksymoops for your architecture?

There is ksymoops for s390 and it should be able to disassemble the code
as well. But you need all sorts of files to feed into ksymoops to get
something out of it. At least I often get bug reports with the console
output attached and it simply saves time if I can see the disassembly
without an extra step.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


