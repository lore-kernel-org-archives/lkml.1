Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbXIRJEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbXIRJEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXIRJEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:04:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45689 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbXIRJEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:04:14 -0400
Date: Tue, 18 Sep 2007 10:04:08 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mingming Cao <cmm@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       ext4 development <linux-ext4@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] JBD slab cleanups
Message-ID: <20070918090407.GA671@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Badari Pulavarty <pbadari@us.ibm.com>,
	Christoph Lameter <clameter@sgi.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com> <20070902152801.GA19962@infradead.org> <Pine.LNX.4.64.0709030051370.31366@schroedinger.engr.sgi.com> <20070903134043.GB28962@infradead.org> <Pine.LNX.4.64.0709031230190.2131@schroedinger.engr.sgi.com> <20070903193308.GA7771@infradead.org> <1189796027.3841.6.camel@localhost.localdomain> <1190057391.3845.22.camel@localhost.localdomain> <1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com> <1190069851.6725.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190069851.6725.6.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 03:57:31PM -0700, Mingming Cao wrote:
> Here is the incremental small cleanup patch. 
> 
> Remove kamlloc usages in jbd/jbd2 and consistently use jbd_kmalloc/jbd2_malloc.

Shouldn't we kill jbd_kmalloc instead?

