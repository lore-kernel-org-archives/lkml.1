Return-Path: <linux-kernel-owner+w=401wt.eu-S1422820AbXBVDoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422820AbXBVDoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 22:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965114AbXBVDoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 22:44:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50342 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965100AbXBVDon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 22:44:43 -0500
Date: Thu, 22 Feb 2007 03:44:24 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Neil Brown <neilb@suse.de>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>,
       schwidefsky@de.ibm.com
Subject: Re: Block layer still stack abuser?
Message-ID: <20070222034424.GC9027@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Neil Brown <neilb@suse.de>, Pierre Ossman <drzeus-list@drzeus.cx>,
	LKML <linux-kernel@vger.kernel.org>, schwidefsky@de.ibm.com
References: <45D59C3C.4090403@drzeus.cx> <17885.1120.437885.35438@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17885.1120.437885.35438@notabene.brown>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 01:48:00PM +1100, Neil Brown wrote:
> Might this:
>    http://lkml.org/lkml/2007/2/10/22
> 
> relate to your question?
> If you are talking about stacking block device (via dm or md), then a
> patch to fix this in in -mm but there are or were some potential
> issues in dm that seem to be holding it up.

What are the current blocking issues?  There are a lot of users of dm/md
double-stacking (e.g. mirroring + multipath) that are in deep trouble
currently and could be helped greatly with this patch.
