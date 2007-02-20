Return-Path: <linux-kernel-owner+w=401wt.eu-S965332AbXBTQNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965332AbXBTQNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965345AbXBTQNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:13:05 -0500
Received: from thunk.org ([69.25.196.29]:50664 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965332AbXBTQND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:13:03 -0500
Date: Tue, 20 Feb 2007 11:12:53 -0500
From: Theodore Tso <tytso@mit.edu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
Message-ID: <20070220161252.GE3170@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Woodhouse <dwmw2@infradead.org>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165449.5845.18238.sendpatchset@localhost.localdomain> <20070219105445.GA16930@infradead.org> <1171976753.4039.27.camel@sauron> <20070220145503.GC3170@thunk.org> <1171984555.3518.5.camel@hades.cambridge.redhat.com> <20070220152259.GD3170@thunk.org> <1171985598.3518.8.camel@hades.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171985598.3518.8.camel@hades.cambridge.redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 03:33:18PM +0000, David Woodhouse wrote:
> On Tue, 2007-02-20 at 10:22 -0500, Theodore Tso wrote:
> > But __be32 will catch the same errors these days because the be/le
> > types use __bitwise now, right?  So use of the __be32/__be64 types should
> > be preferred since it also will work with sparse, I would think.
> 
> Does __bitwise work in gcc? I thought it was only for sparse?

Sorry, you're right and I'm wrong.  I thought it was a gcc attribute
as well, but it looks like it isn't.  

						- Ted

