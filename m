Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZKQK07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZKQK07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 05:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZKQK06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 05:26:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34471 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbZKQK06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 05:26:58 -0500
Date: Tue, 17 Nov 2009 05:27:01 -0500
From: Christoph Hellwig <hch@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Kill PF_MEMALLOC abuse
Message-ID: <20091117102701.GA16472@infradead.org>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com> <20091117101526.GA4797@infradead.org> <20091117192232.3DF9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117192232.3DF9.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 07:24:42PM +0900, KOSAKI Motohiro wrote:
> if xfsbufd doesn't only write out dirty data but also drop page,
> I agree you. 

It then drops the reference to the buffer which drops references to the
pages, which often are the last references, yes.

