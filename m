Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbXEIPr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbXEIPr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757693AbXEIPrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 11:47:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758170AbXEIPrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 11:47:16 -0400
Date: Wed, 9 May 2007 16:47:11 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Heinz Mauelshagen <hjm@redhat.com>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
Message-ID: <20070509154711.GC18152@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Heinz Mauelshagen <hjm@redhat.com>
References: <20070508194845.GC24114@agk.fab.redhat.com> <20070508174159.7d78a275.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508174159.7d78a275.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 05:41:59PM -0700, Andrew Morton wrote:
> On Tue, 8 May 2007 20:48:45 +0100
> Alasdair G Kergon <agk@redhat.com> wrote:
> > +#define BIO_LIST(bl) \
> > +	struct bio_list bl = BIO_LIST_INIT
 
> BIO_LIST is a strange name for something which initialises storage.
 
Those came by analogy with list.h, with list_head -> bio_list:

  #define LIST_HEAD(name) \
        struct list_head name = LIST_HEAD_INIT(name)

We could use something like INIT_BIO_LIST(bl) for that, but perhaps it would be
more readable always written out in full?
   struct bio_list bl = BIO_LIST_INIT;

Alasdair
-- 
agk@redhat.com
