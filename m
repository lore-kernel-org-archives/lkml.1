Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYFRMwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYFRMwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYFRMve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:51:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbYFRMvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:51:33 -0400
Date: Wed, 18 Jun 2008 08:51:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Gaudenz Steinlin <gaudenz@debian.org>, linux-kernel@vger.kernel.org,
       486798@bugs.debian.org, josejx@gentoo.org
Subject: Re: [PATCH] restore export of handle_mm_fault for Mac on Linux
Message-ID: <20080618125131.GA2097@infradead.org>
References: <20080618101402.GF15718@soziologie.ch> <20080618114906.GA23788@infradead.org> <18521.846.628816.525787@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18521.846.628816.525787@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 10:45:02PM +1000, Paul Mackerras wrote:
> > Has been rejected a few times.  An now that we actually have kvm
> > for powerpc in tree MOL should just merge with that project and
> > do the right things in tree instead of beeing a really hacky
> > module subverting the VM.
> 
> We don't have KVM for the "classic" 32-bit PowerPC processors, only
> for the 44x family.  And doing KVM for the classic 32-bit processors
> would probably involve just as much hackery as MOL. :)

I don't think so.  Doing it properly in-tree will mean that it is

  a) properly reviewed
  b) means we can do the major VM bits in the kernel without these
     really stupid exports

Have you looked at MOL recently?  It's more than disgusting.

And in addition to these issue we do of course as policy not add
random hooks in the kernel tree for out of tree stuff.  Especially
for hacks like this that don't even have the intention to get merged.
