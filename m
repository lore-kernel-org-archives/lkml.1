Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbZEBMou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbZEBMou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 08:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZEBMoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 08:44:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbZEBMoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 08:44:39 -0400
Date: Sat, 2 May 2009 08:44:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: tridge@samba.org
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090502124436.GA14621@infradead.org>
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com> <20090501210109.GA3079@infradead.org> <20090502013729.GI6996@linux.vnet.ibm.com> <20090502015927.GJ8822@parisc-linux.org> <18940.3862.34000.615391@samba.org> <20090502092204.GA32066@infradead.org> <18940.4762.726933.677059@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18940.4762.726933.677059@samba.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 07:30:02PM +1000, tridge@samba.org wrote:
> The non-technical reasons for this patch are available to anyone who
> cares to read any of the many news sites that discuss recent
> events. The fact that I can't discuss those reasons shouldn't preclude
> me from proposing a technical solution which tries to minimise the
> impact on Linux users.

Yes, the fact that you let someone else send a patch for you, refuse to
state any reason for it and when asked for it talk around the problems
is a very good reason not to bother with a patch.

If you think there is a patent problem with long file names and have
a good argument for it we should just make the reduce functionality
the default until it's settled.  If you do not have a good argument
we should drop this completely.

> I'm hoping that you and others will look at the proposed technical
> solution to the non-technical problem, and perhaps suggest better
> approaches. There are a wide variety of approaches to avoiding this
> problem, and we need to work out which, if any, should be part of the
> kernel.org releases.

Sorting out a problem starts with clearly stating what the problem is.

