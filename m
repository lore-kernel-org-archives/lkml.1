Return-Path: <linux-kernel-owner+w=401wt.eu-S1759789AbXEPLbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789AbXEPLbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbXEPLbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:31:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:48784 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756394AbXEPLa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:30:59 -0400
Subject: Re: [RFC/PATCH 2/2] Make map_vm_area() static
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070516065743.GB9884@lst.de>
References: <20070516034600.8A7C6DDEE7@ozlabs.org>
	 <20070516065743.GB9884@lst.de>
Content-Type: text/plain
Date: Wed, 16 May 2007 17:54:19 +1000
Message-Id: <1179302060.32247.218.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 08:57 +0200, Christoph Hellwig wrote:
> On Wed, May 16, 2007 at 01:45:29PM +1000, Benjamin Herrenschmidt wrote:
> > map_vm_area() is only ever used inside of mm/vmalloc.c. This makes
> > it static and removes the prototype.
> 
> Looks good.

Thanks. However, patch 1/2 is the interesting one for which I'd like
to get your comment since you asked me to do it this way :-)

(I know, I incorrectly labelled it powerpc: while it's generic code)

Cheers,
Ben.


