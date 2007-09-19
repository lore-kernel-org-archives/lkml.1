Return-Path: <linux-kernel-owner+w=401wt.eu-S1762936AbXISR70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762936AbXISR70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXISR7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:59:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38464 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbXISR7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:59:14 -0400
Date: Wed, 19 Sep 2007 18:59:09 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Dave Hansen <haveblue@us.ibm.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 03/24] create cleanup helper svc_msnfs()
Message-ID: <20070919175909.GA24530@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Dave Hansen <haveblue@us.ibm.com>,
	Jan Engelhardt <jengelh@computergmbh.de>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182721.8EF73A09@kernel> <Pine.LNX.4.64.0709191939080.10201@fbirervta.pbzchgretzou.qr> <1190223930.26982.109.camel@localhost> <1190224446.6734.4.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190224446.6734.4.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 01:54:06PM -0400, Trond Myklebust wrote:
> > If it were some kind of larger API, we could come up with something
> > better.  But, for a single isolated user, I think it is OK.
> 
> The msnfs option means enable the use of MS Windows share locks, so yes,
> the name is appropriate.

Yepp.  While we're at it, can we please kill the silly ifdefs for it
(once Dave's patches are merged to avoid conflicts).  The code has always
been enabled since it was introduced, it's an export option anyway and
to make things worse the ifdef needs to be disabled in multiple files
to make it consistant..


> 
> Trond
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
---end quoted text---
