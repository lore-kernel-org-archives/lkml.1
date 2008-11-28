Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbYK1Nrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbYK1Nrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 08:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbYK1NrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:47:23 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:48147 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbYK1NrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:47:22 -0500
Date: Fri, 28 Nov 2008 13:47:12 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jamie Lokier <jamie@shareable.org>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v4] relatime: Make relatime smarter
Message-ID: <20081128134712.GC5058@srcf.ucam.org>
References: <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127163535.775729bf@lxorguk.ukuu.org.uk> <20081127164754.GC22963@srcf.ucam.org> <20081127165929.GA23366@srcf.ucam.org> <20081127170615.GB14991@infradead.org> <20081127175813.GA24354@srcf.ucam.org> <20081128111809.GH6138@shareable.org> <20081128134055.GQ25548@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128134055.GQ25548@parisc-linux.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 06:40:55AM -0700, Matthew Wilcox wrote:
> On Fri, Nov 28, 2008 at 11:18:09AM +0000, Jamie Lokier wrote:
> > Matthew Garrett wrote:
> > > The time between atime updates can be configured at boot
> > > with the relatime_interval kernel argument, or at runtime through a sysctl.
> > 
> > Shouldn't it be a per-mount value, with defaults coming from the sysctl?
> 
> Perhaps a more sensible question would be "Why make it configurable at
> all?"  What's wrong with hardcoding 24 hours?  Or, to put it another
> way, who wants to change it from 24 hours, and why?

There's approximately no cost to it, and arguably use cases that would 
benefit. I don't think they'd be common enough to benefit from the 
additional complexity of making it per-mount.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
