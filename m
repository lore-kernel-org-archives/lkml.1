Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbZCRRW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbZCRRW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbZCRRWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:22:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:50005 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569AbZCRRV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:21:59 -0400
Subject: Re: [PATCH] BTRFS: Transpose parent_objectid and parent_gen in
 struct btrfs_fid
From: David Woodhouse <dwmw2@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>, balajirrao@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <21667.1237395905@redhat.com>
References: <1237395629.10384.2.camel@think.oraclecorp.com>
	 <20090318161626.16521.91662.stgit@warthog.procyon.org.uk>
	 <21667.1237395905@redhat.com>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 17:21:49 +0000
Message-Id: <1237396909.27829.102.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 17:05 +0000, David Howells wrote:
> Chris Mason <chris.mason@oracle.com> wrote:
> 
> > Won't this confuse any handles the clients already have if the server
> > reboots with the new handle format?
> 
> Perhaps, but it's probably early enough in BTRFS's life to get away with it.

True. It's not that hard to handle compatibility if we really care,
either.

But this struct is packed anyway -- we're not changing much on the wire;
it's just a case of how efficient it is to load that single uint64_t
from an unaligned location. Is that _really_ something we're ever going
to notice?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

