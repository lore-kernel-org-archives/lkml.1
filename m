Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbZF3Ubq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbZF3Ubq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZF3Ubj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:31:39 -0400
Received: from outbound-mail-309.bluehost.com ([67.222.54.2]:35053 "HELO
	outbound-mail-309.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754335AbZF3Ubi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:31:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hX5+YDtC3+Vjrm4fvdt/KO1bS1LH1tE+kY95nrwp591Vfmpwjj0w9o2F+CFCL7dmPdBtBHHP6KOme76FprgfexBg0zswVwgplAcZvaTFMd6QurV5FOKSMv2TdIx01vjs;
Date: Tue, 30 Jun 2009 13:31:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: pci tree build failure
Message-ID: <20090630133137.1bde0dc6@jbarnes-g45>
In-Reply-To: <20090630022453.GE24061@linux.intel.com>
References: <20090630120727.24450bab.sfr@canb.auug.org.au>
	<20090629191324.5c86bbc0@jbarnes-g45>
	<20090630022453.GE24061@linux.intel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009 19:24:53 -0700
Matthew Wilcox <willy@linux.intel.com> wrote:

> On Mon, Jun 29, 2009 at 07:13:24PM -0700, Jesse Barnes wrote:
> > On Tue, 30 Jun 2009 12:07:27 +1000
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > Hi Jesse,
> > > 
> > > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > > 
> > > ERROR: "pci_claim_resource" [drivers/pcmcia/yenta_socket.ko]
> > > undefined!
> > > 
> > > Caused by commit 6bb04b65dbff5a5bb01617351dbb0af577084752
> > > ("yenta: Use pci_claim_resource").  yenta can be built as a
> > > module, but pci_claim_resource is not exported ...
> > > 
> > > I have used the pci tree from next-20090629 for today.
> > 
> > Damn, thought I built that.  linux-next earns its keep yet again.
> 
> Sorry about that.  I thought I'd checked that.  Must have been
> confused with another function.  There do seem to be legitimate
> *drivers* that could use it (i2o for one), so I propose making it a
> full-bodied 'EXPORT_SYMBOL' and not bother with the _GPL tag.
> Thoughts?

Fine by me; that matches most of the PCI core (though the slots bits
are _GPL).

-- 
Jesse Barnes, Intel Open Source Technology Center
