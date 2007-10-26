Return-Path: <linux-kernel-owner+w=401wt.eu-S1762828AbXJZPJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762828AbXJZPJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXJZPJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:09:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55651 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbXJZPJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:09:51 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Kay Sievers <kay.sievers@vrfy.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, greg@kroah.com,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <1193410087.6914.34.camel@twins>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
	 <1191325226.13204.63.camel@twins>
	 <200710022205.05295.nickpiggin@yahoo.com.au>
	 <1191406506.4093.35.camel@lov.localdomain>  <1191407872.5572.7.camel@lappy>
	 <1191418525.4093.87.camel@lov.localdomain> <1193410087.6914.34.camel@twins>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 17:10:51 +0200
Message-Id: <1193411451.2431.13.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19opZIWzrfe90rJpnl5vgIKEA+mKGr4Cb6VsG0
 T7ThpmqPKERVpKDRNAbutEqkQa6pDT4iNfYP9XlhCL8YKaXusu
 evIhEmHY3/8r+r0RyS6D5k/rbMAVKRA
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 16:48 +0200, Peter Zijlstra wrote:

> I appreciate the sysfs people their opinion that /sys/bdi/ might not be the
> best from their POV, however I'm not seeing where to hook the BDI object from
> so that it all makes sense, a few of the things are currently not exposed in
> sysfs at all, like the NFS and FUSE things.

What happended to the idea to create a "bdi" class, and have the
existing devices as parents, and for stuff that is not (not now, or
never) in sysfs, no parent is set.

Thanks,
Kay

