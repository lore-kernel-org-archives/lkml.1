Return-Path: <linux-kernel-owner+w=401wt.eu-S932392AbXGYBJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbXGYBJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 21:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758142AbXGYBJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 21:09:31 -0400
Received: from ozlabs.org ([203.10.76.45]:54280 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594AbXGYBJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 21:09:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18086.41665.610756.139183@cargo.ozlabs.ibm.com>
Date: Wed, 25 Jul 2007 11:09:21 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
In-Reply-To: <46A5E610.7000508@shadowen.org>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.392129000@pademelon.sonytel.be>
	<20070718163637.3f0e0164.akpm@linux-foundation.org>
	<46A5E610.7000508@shadowen.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft writes:

> Ok, this is something we need to decide on.  Currently we only ask for
> consistent spacing on all the mathematic operators.  This is mostly as
> we do see a large number of non-spaced uses in defines and the like.
> 
> I am happy to expand these tests so they are always spaced on both sides
> style if that is the preference.

It depends very much on the context - on the precedence and relative
importance of one operator with respect to other operators and the
statement as a whole.  In general I prefer spaces around binary
operators, but there are situations where not putting spaces around
some operators can enhance the readability of the statement as a
whole.

If checkpatch.pl starts whinging about operators without spaces that
will just be yet another reason not to use it IMHO.

Also, I prefer the style where the ? and : operators have a space
after them but not before them, rather than a space either side.

Paul.
