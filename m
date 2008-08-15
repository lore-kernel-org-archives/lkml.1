Return-Path: <linux-kernel-owner+w=401wt.eu-S1761217AbYHOWF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761217AbYHOWF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYHOWFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:05:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:56619 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYHOWFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:05:14 -0400
Date: Fri, 15 Aug 2008 15:05:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Rik van Riel <riel@redhat.com>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Eric Paris <eparis@redhat.com>,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, hch@infradead.org, andi@firstfloor.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080815150509.20ffb91d@infradead.org>
In-Reply-To: <20080815201622.GD31584@cs.cmu.edu>
References: <1218645375.3540.71.camel@localhost.localdomain>
	<20080813172437.3ed90b0d@lxorguk.ukuu.org.uk>
	<1218646065.3540.75.camel@localhost.localdomain>
	<20080813173722.13c9c306@lxorguk.ukuu.org.uk>
	<1218646833.3540.82.camel@localhost.localdomain>
	<20080813205906.559d3f37@lxorguk.ukuu.org.uk>
	<2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com>
	<20080813173529.7069b5f1@cuia.bos.redhat.com>
	<20080815201622.GD31584@cs.cmu.edu>
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

On Fri, 15 Aug 2008 16:16:22 -0400
Jan Harkes <jaharkes@cs.cmu.edu> wrote:

> > I believe we really do need the block-on-open.  

I believe more that we need block-on-read ;-)
(on open we can start an async scan to cut latency)

read() (or mmap etc) is where the actual use/transfer of
contaminated data happens, not in the open.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
