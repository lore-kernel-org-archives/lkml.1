Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYLCRIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYLCRIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 12:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYLCRIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 12:08:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45675 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYLCRIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:08:31 -0500
Date: Wed, 3 Dec 2008 12:08:29 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 3/6] integrity: IMA as an integrity service provider
Message-ID: <20081203170829.GA32608@infradead.org>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com> <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com> <1228260925.2971.240.camel@nimitz> <20081203130301.GA9681@infradead.org> <1228323355.2971.259.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228323355.2971.259.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 08:55:54AM -0800, Dave Hansen wrote:
> On Wed, 2008-12-03 at 08:03 -0500, Christoph Hellwig wrote:
> > On Tue, Dec 02, 2008 at 03:35:25PM -0800, Dave Hansen wrote:
> > > If you're looking for another way to split your patch out, you could
> > > just stick use inode->integrity for the first patch, then introduce your
> > > radix-tree in a subsequent patch.  It would be functionally fine, and
> > > more clearly separate out the ideas.
> > 
> > This was done earlier and is a really bad thing for review.  Just as the
> > breakout happening in this round.
> 
> If Christoph and I tell you conflicting things, it goes without saying
> to listen to Christoph.  :)

Or listen to what makes more sense.  It's not the most important comment
of the review anyway..

