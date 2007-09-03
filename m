Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbXICHz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbXICHz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 03:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbXICHzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 03:55:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36856 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753170AbXICHzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 03:55:08 -0400
Date: Mon, 3 Sep 2007 00:55:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Christoph Hellwig <hch@infradead.org>
cc: Mingming Cao <cmm@us.ibm.com>, linux-fsdevel@vger.kernel.org,
       adilger@clusterfs.com, sho@tnes.nec.co.jp,
       ext4 development <linux-ext4@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] JBD: slab management support for large block(>8k)
In-Reply-To: <20070902152801.GA19962@infradead.org>
Message-ID: <Pine.LNX.4.64.0709030051370.31366@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com> <20070828190735.292638294@sgi.com>
 <1188432669.3799.35.camel@localhost.localdomain> <1188434857.3799.76.camel@localhost.localdomain>
 <1188605538.3837.51.camel@localhost.localdomain> <20070901183922.GA12907@infradead.org>
 <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com>
 <20070902152801.GA19962@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2007, Christoph Hellwig wrote:

> > We are doing what you describe right now. So the current code is broken?
> Yes.

How about getting rid of the slabs there and use kmalloc? Kmalloc in mm 
(and therfore hopefully 2.6.24) will convert kmallocs > PAGE_SIZE to page 
allocator calls. Not sure what to do about the 1k and 2k requests though.

