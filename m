Return-Path: <linux-kernel-owner+w=401wt.eu-S1762273AbYA1Tbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762273AbYA1Tbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbYA1Tb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:31:28 -0500
Received: from bebe.enoyolf.org ([24.173.215.190]:50633 "EHLO bebe.enoyolf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbYA1Tb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:31:27 -0500
X-Greylist: delayed 1061 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2008 14:31:26 EST
X-Mailer: exmh enoyolf.org version 2.7.2.1 01/17/2005 with nmh-1.1
In-reply-to: <200801281404.54155.konrad@darnok.org> 
References: <20080125220629.GA25325@andromeda.dapyr.net> <20080126220123.d20dd393.akpm@linux-foundation.org>  <200801281404.54155.konrad@darnok.org> 
To: Konrad Rzeszutek <konrad@darnok.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com, darnok@68k.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com,
       arjan@infradead.org, michaelc@cs.wisc.edu,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] Add iSCSI iBFT support (v0.4.5) 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 28 Jan 2008 13:11:33 -0600
Message-ID: <22101.1201547493@bebe.enoyolf.org>
From: Doug Maxey <dwm@enoyolf.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 28 Jan 2008 14:04:51 EST, Konrad Rzeszutek wrote:
> > > +EXPORT_SYMBOL(find_ibft);
> >
> > Is this x86-specific?  Are suitable Kconfig dependencies in place?
> 
> Originally I had it to be x86-specific but was told that I should make it all 
> platforms since the IBFT is platform independent. Somebody can very well 
> insert a NIC with IBFT on a IA64 machine or PPC.
> 

I would beg to differ regarding the powerpc.  On powerpc, the bios is
invisible and ignored.  We have our own "special" way, via the device-tree
in procfs.

++doug

