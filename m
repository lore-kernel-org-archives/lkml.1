Return-Path: <linux-kernel-owner+w=401wt.eu-S1752108AbZLUNns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbZLUNns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 08:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbZLUNnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 08:43:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59754 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbZLUNnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 08:43:46 -0500
Date: Mon, 21 Dec 2009 08:43:44 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org,
       Benjamin Marzinski <bmarzins@redhat.com>,
       David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH 2/2] gfs2: Use CALLER_ADDR0 macro.
Message-ID: <20091221134344.GA17372@infradead.org>
References: <1261332469-25298-1-git-send-email-tfransosi@gmail.com> <1261332469-25298-2-git-send-email-tfransosi@gmail.com> <1261387361.2200.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261387361.2200.6.camel@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 09:22:41AM +0000, Steven Whitehouse wrote:
> Hi,
> 
> Looks fairly harmless, even though I don't entirely see the point. Do
> you want me to add this to me tree?

We also have a _RET_IP_ macro that does the same and has a much more
useful name.  And given that we need the address as void pointer to
print it using our printk extension both seem a bit supoptimal.

Given that a lot of tracing code needs this a bit of standardization
would be useful - more important for the type to store the address than
just the macro name.

