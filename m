Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbXCHQqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbXCHQqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXCHQqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:46:07 -0500
Received: from nevyn.them.org ([66.93.172.17]:57787 "EHLO nevyn.them.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbXCHQqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:46:06 -0500
X-Greylist: delayed 1430 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2007 11:46:06 EST
Date: Thu, 8 Mar 2007 11:21:58 -0500
From: Daniel Jacobowitz <dan@debian.org>
To: Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>, David Brown <dmlb2000@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
Message-ID: <20070308162158.GA5702@caradoc.them.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Roman Zippel <zippel@linux-m68k.org>,
	David Brown <dmlb2000@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	gdb@sourceware.org
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com> <20070306092917.GA5226@infradead.org> <200703080318.04631.zippel@linux-m68k.org> <20070308090031.GB7373@infradead.org> <1173369229.3550.2.camel@laptopd505.fenrus.org> <20070308160852.GB9916@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308160852.GB9916@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 04:08:52PM +0000, Christoph Hellwig wrote:
> No, no no.  We should never export PAGE_SIZE.  We might export NBPG
> as deprecated symbol for gdb if it really needs it, but that should
> happen only on a.out systems, and it it should be a true constant,
> not depending on PAGE_SIZE.
> 
> I've Cc'ed the gdb list on whether they have any comments on this
> issue.

Sounds reasonable.  I do not believe that GDB has any dependence on
PAGE_SIZE; bfd (i.e. both gdb and binutils) use NBPG on a large number
of systems.  Looks like i386, alpha, m68k, s390, vax - but don't quote
me on that, I had to guess from the configure script.

-- 
Daniel Jacobowitz
CodeSourcery
