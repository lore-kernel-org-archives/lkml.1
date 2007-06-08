Return-Path: <linux-kernel-owner+w=401wt.eu-S1764218AbXFHOn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764218AbXFHOn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbXFHOnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:43:50 -0400
Received: from lazybastard.de ([212.112.238.170]:38133 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbXFHOnt (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:43:49 -0400
Date: Fri, 8 Jun 2007 15:19:05 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, carsteno@de.ibm.com,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070608131905.GB20718@lazybastard.org>
References: <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <6934efce0706060907n209fe6bcnb470101196aa9c55@mail.gmail.com> <20070606161621.GA20247@infradead.org> <6934efce0706061126n551cccaeg68a0def87457911@mail.gmail.com> <20070607193707.GA17144@infradead.org> <6934efce0706071411y6d184629i5ce0694175bef164@mail.gmail.com> <20070607211519.GA22348@infradead.org> <6934efce0706071559j24978c15kc42914677dc8408e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6934efce0706071559j24978c15kc42914677dc8408e@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 June 2007 15:59:00 -0700, Jared Hulbert wrote:
> 
> Gee I think it seems logfs would be a better choice.  Jffs2 and
> ubifs(jffs3) for that matter combine node and node header in series
> which means your data nodes aren't aligned to page boundarys. Logfs
> nodes could be more easily aligned.

That used to be the case before I did a format change.  Compression
pretty much requires a format very similar to JFFS2.  The alternative
would be _huge_ complexity.

However, it would be possible to create specialized XIP segments with
the old page-aligned format.  Supporting two kinds of segment format is
still simpler than supporting compression with the old format.

Jörn

-- 
With a PC, I always felt limited by the software available. On Unix,
I am limited only by my knowledge.
-- Peter J. Schoenster
