Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbXFRGA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbXFRGA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 02:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbXFRGAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 02:00:18 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:57493 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbXFRGAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 02:00:16 -0400
Date: Mon, 18 Jun 2007 14:58:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: More __meminit annotations.
Message-ID: <20070618055842.GA17858@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Yasunori Goto <y-goto@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sam Ravnborg <sam@ravnborg.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20070618045229.GA31635@linux-sh.org> <20070618143943.B108.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618143943.B108.Y-GOTO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 02:49:24PM +0900, Yasunori Goto wrote:
> > -static inline unsigned long zone_absent_pages_in_node(int nid,
> > +static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
> >  						unsigned long zone_type,
> >  						unsigned long *zholes_size)
> >  {
> 
> I thought __meminit is not effective for these static functions,
> because they are inlined function. So, it depends on caller's 
> defenition. Is it wrong? 
> 
Ah, that's possible, I hadn't considered that. It seems to be a bit more
obvious what the intention is if it's annotated, especially as this is
the convention that's used by the rest of mm/page_alloc.c. A bit more
consistent, if nothing more.
