Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbZJ0T7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbZJ0T7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbZJ0T7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:59:05 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:27406 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722AbZJ0T7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:59:04 -0400
Date: Tue, 27 Oct 2009 13:59:07 -0600
From: Alex Chiang <achiang@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, Gary Hade <garyhade@us.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 1/5] mm: add numa node symlink for memory section in
	sysfs
Message-ID: <20091027195907.GJ14102@ldl.fc.hp.com>
References: <20091022040814.15705.95572.stgit@bob.kio> <20091022041510.15705.5410.stgit@bob.kio> <alpine.DEB.2.00.0910221249030.26631@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910221249030.26631@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for ACKing, David.

S390 guys, I cc'ed you on this patch because I heard a rumour
that your memory sections may belong to more than one NUMA node?
Is that true? If so, how would you like me to handle that
situation?

Any comments on this patch series would be appreciated.

Thanks.
/ac

* David Rientjes <rientjes@google.com>:
> On Wed, 21 Oct 2009, Alex Chiang wrote:
> 
> > Commit c04fc586c (mm: show node to memory section relationship with
> > symlinks in sysfs) created symlinks from nodes to memory sections, e.g.
> > 
> > /sys/devices/system/node/node1/memory135 -> ../../memory/memory135
> > 
> > If you're examining the memory section though and are wondering what
> > node it might belong to, you can find it by grovelling around in
> > sysfs, but it's a little cumbersome.
> > 
> > Add a reverse symlink for each memory section that points back to the
> > node to which it belongs.
> > 
> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Cc: Gary Hade <garyhade@us.ibm.com>
> > Cc: Badari Pulavarty <pbadari@us.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Alex Chiang <achiang@hp.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> Very helpful backlinks to memory section nodes even though I have lots of 
> memory directories on some of my test machines :)
