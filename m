Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYHQX0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYHQX0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 19:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbYHQX0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 19:26:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:43376 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbYHQX0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 19:26:32 -0400
Date: Sun, 17 Aug 2008 16:26:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, Rik van Riel <riel@redhat.com>,
       "Press, Jonathan" <Jonathan.Press@ca.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       hch@infradead.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080817162603.065c756f@infradead.org>
In-Reply-To: <1219015177.27389.1.camel@localhost.localdomain>
References: <1218645375.3540.71.camel@localhost.localdomain>
	<20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
	<1218646065.3540.75.camel@localhost.localdomain>
	<20080813173722.13c9c306@lxorguk.ukuu.org.uk>
	<1218646833.3540.82.camel@localhost.localdomain>
	<20080813205906.559d3f37@lxorguk.ukuu.org.uk>
	<2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com>
	<20080813173529.7069b5f1@cuia.bos.redhat.com>
	<20080815201622.GD31584@cs.cmu.edu>
	<20080815150509.20ffb91d@infradead.org>
	<1219015177.27389.1.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008 19:19:37 -0400
Eric Paris <eparis@redhat.com> wrote:

> On Fri, 2008-08-15 at 15:05 -0700, Arjan van de Ven wrote:
> > On Fri, 15 Aug 2008 16:16:22 -0400
> > Jan Harkes <jaharkes@cs.cmu.edu> wrote:
> > 
> > > > I believe we really do need the block-on-open.  
> > 
> > I believe more that we need block-on-read ;-)
> > (on open we can start an async scan to cut latency)
> > 
> > read() (or mmap etc) is where the actual use/transfer of
> > contaminated data happens, not in the open.
> 
> I could probably buy that, but I don't know how an HSM would work.
> Would we have everything we need at open for them to fire off?
> 
> /me is HSM clueless and trying to include their needs is proving a
> challenge.

I bet it's the same; until you read/mmap... no need to get the data.

you wouldn't want an "ls -l" or "find" to restore your entire system
from tape after all :)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
