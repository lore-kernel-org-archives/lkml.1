Return-Path: <linux-kernel-owner+w=401wt.eu-S932716AbXGYBXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716AbXGYBXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 21:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759065AbXGYBWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 21:22:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58943 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758496AbXGYBWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 21:22:50 -0400
Date: Tue, 24 Jul 2007 18:21:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Andy Whitcroft <apw@shadowen.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Message-Id: <20070724182130.6ebcca00.akpm@linux-foundation.org>
In-Reply-To: <18086.41665.610756.139183@cargo.ozlabs.ibm.com>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.392129000@pademelon.sonytel.be>
	<20070718163637.3f0e0164.akpm@linux-foundation.org>
	<46A5E610.7000508@shadowen.org>
	<18086.41665.610756.139183@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 11:09:21 +1000 Paul Mackerras <paulus@samba.org> wrote:

> Also, I prefer the style where the ? and : operators have a space
> after them but not before them, rather than a space either side.

Could I point out that your likes and dislikes are immaterial?  The whole
point here is to get kernel code looking consistent.  That means that
basically everyone ends up doing things which they'd prefer not to do. 
That certainly applies to me.  

The idea is that the benefit of making things consistent exceeds the costs
of some individuals adopting styles which they are less used to.


So telling people what you do and don't like is simply irrelevant, except
for when it is used as an input in determining what the standard kernel
style is to be.  (And that is largely determined by observing what we have
now).

And sure, major subsytems can and do go off and do their own thing - ia64
for example has done a lot of that, pretty consistently.  The world hasn't
ended as a result.
