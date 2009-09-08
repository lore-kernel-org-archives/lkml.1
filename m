Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbZIHI3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbZIHI3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 04:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZIHI3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 04:29:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:47346 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbZIHI3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 04:29:17 -0400
Date: Tue, 8 Sep 2009 01:32:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH] C2 could be mapped to C3 so need a flush cache
Message-ID: <20090908013240.51e39d1e@infradead.org>
In-Reply-To: <3877989d0909080120w78fce005le465828a5e1ae2b7@mail.gmail.com>
References: <3877989d0909071926q77aac67cj532137513710025d@mail.gmail.com>
	<20090907204913.2aef5c49@infradead.org>
	<3877989d0909072209g454d92feuc0d3cdbd95a13a9c@mail.gmail.com>
	<20090908005236.1fbfdd13@infradead.org>
	<3877989d0909080120w78fce005le465828a5e1ae2b7@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009 16:20:52 +0800
Luming Yu <luming.yu@gmail.com> wrote:

> > Do you have an example of a specific machine where this is fscked
> > up? (if so, it's blacklist worthy.. probably worth blacklisting just
> > outright doing C states on it)
> 
> Those boxes that have c2 lapic timer stop issue is supposed to need
> this patch. But I don't have such kind of system. So test and
> comments are needed by those who actually have such kind of box.

I find that highly unlikely; this software cache flush codepath hasn't
applied to any CPU sold in the last few years....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
