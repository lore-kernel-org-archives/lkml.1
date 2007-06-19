Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbXFSTEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbXFSTEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932169AbXFSTEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:04:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47056 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763872AbXFSTEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:04:12 -0400
Date: Tue, 19 Jun 2007 20:04:07 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH -mm] add a kmem_cache for nsproxy objects
Message-ID: <20070619190406.GA3830@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Cedric Le Goater <clg@fr.ibm.com>,
	Christoph Lameter <clameter@sgi.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Herbert Poetzl <herbert@13thfloor.at>,
	Pavel Emelianov <xemul@openvz.org>
References: <4676F0B9.3080408@fr.ibm.com> <20070619113501.a88bba50.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619113501.a88bba50.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 11:35:01AM -0700, Andrew Morton wrote:
> On Mon, 18 Jun 2007 22:53:13 +0200
> Cedric Le Goater <clg@fr.ibm.com> wrote:
> 
> > +static int __init nsproxy_cache_init(void)
> > +{
> > +	nsproxy_cachep = kmem_cache_create("nsproxy", sizeof(struct nsproxy),
> > +					   0, SLAB_PANIC, NULL, NULL);
> > +	return 0;
> > +}
> > +
> 
> Christoph added this cheesy KMEM_CACHE macro.  But I don't immediately recall
> the rationale so I'm a bit reluctant to ask people to use-the-cheesy-macro.
> 
> Perhaps he can remind us why it is there?

Hmm, I must have missed the macro going in.  Frankly speaking I plain hate
it.  It's a rather useless obsfucation.
