Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbZCRRqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbZCRRqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZCRRqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:46:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:39715 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZCRRqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:46:12 -0400
Subject: Re: [PATCH] BTRFS: Transpose parent_objectid and parent_gen in
 struct btrfs_fid
From: David Woodhouse <dwmw2@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>, balajirrao@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <30514.1237397915@redhat.com>
References: <1237396909.27829.102.camel@macbook.infradead.org>
	 <1237395629.10384.2.camel@think.oraclecorp.com>
	 <20090318161626.16521.91662.stgit@warthog.procyon.org.uk>
	 <21667.1237395905@redhat.com>  <30514.1237397915@redhat.com>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 17:46:00 +0000
Message-Id: <1237398360.27829.105.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 17:38 +0000, David Howells wrote:
> If the CPU doing the load/store throws a misalignment exception or just
> ignores the instruction because it's misaligned, it might make for interesting
> debugging.

That would require a 64-bit CPU which doesn't naturally handle unaligned
loads, and a compiler bug.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

