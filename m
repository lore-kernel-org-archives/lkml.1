Return-Path: <linux-kernel-owner+w=401wt.eu-S1759049AbYEYTYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759049AbYEYTYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbYEYTYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:24:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526AbYEYTYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:24:15 -0400
Date: Sun, 25 May 2008 15:24:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, swhiteho@redhat.com
Subject: Re: [patch 04/14] gfs2: dont call permission()
Message-ID: <20080525192414.GB1949@infradead.org>
References: <20080521171458.077908538@szeredi.hu> <20080521171546.697638614@szeredi.hu> <20080523091805.GB27119@infradead.org> <E1JzTsy-0001b8-Cr@pomaz-ex.szeredi.hu> <E1JzU4Y-0001dS-3H@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JzU4Y-0001dS-3H@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 12:00:26PM +0200, Miklos Szeredi wrote:
> And that's true of lookup_one_len() as well, the last bit of horror
> left in this permission() saga.  It's called from lots of places,
> often for doing things it's not at all meant to do (e.g. where caller
> _knows_ it will return negative, etc...).  One day maybe I'll have
> strength to clean that up as well..., but not now.

lookup_one_len is not just a horror for permission, it's a nighmare
in general.  I'm not convinced any use of it except for silly renames
is actually valid.

