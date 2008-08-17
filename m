Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYHQXYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYHQXYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 19:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYHQXYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 19:24:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47563 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbYHQXYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 19:24:07 -0400
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
From: Eric Paris <eparis@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, Rik van Riel <riel@redhat.com>,
       "Press, Jonathan" <Jonathan.Press@ca.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       hch@infradead.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk
In-Reply-To: <20080815150509.20ffb91d@infradead.org>
References: <1218645375.3540.71.camel@localhost.localdomain>
	 <20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
	 <1218646065.3540.75.camel@localhost.localdomain>
	 <20080813173722.13c9c306@lxorguk.ukuu.org.uk>
	 <1218646833.3540.82.camel@localhost.localdomain>
	 <20080813205906.559d3f37@lxorguk.ukuu.org.uk>
	 <2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com>
	 <20080813173529.7069b5f1@cuia.bos.redhat.com>
	 <20080815201622.GD31584@cs.cmu.edu> <20080815150509.20ffb91d@infradead.org>
Content-Type: text/plain
Date: Sun, 17 Aug 2008 19:19:37 -0400
Message-Id: <1219015177.27389.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-15 at 15:05 -0700, Arjan van de Ven wrote:
> On Fri, 15 Aug 2008 16:16:22 -0400
> Jan Harkes <jaharkes@cs.cmu.edu> wrote:
> 
> > > I believe we really do need the block-on-open.  
> 
> I believe more that we need block-on-read ;-)
> (on open we can start an async scan to cut latency)
> 
> read() (or mmap etc) is where the actual use/transfer of
> contaminated data happens, not in the open.

I could probably buy that, but I don't know how an HSM would work.
Would we have everything we need at open for them to fire off?

/me is HSM clueless and trying to include their needs is proving a
challenge.

-Eric

