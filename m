Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbYKLMyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbYKLMyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYKLMyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:54:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYKLMyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:54:35 -0500
Date: Wed, 12 Nov 2008 07:54:29 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>,
       linux-kernel@vger.kernel.org, bfields@fieldses.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
Message-ID: <20081112125429.GA12463@infradead.org>
References: <20081111093426.GS26778@kernel.dk> <20081111093540.GT26778@kernel.dk> <20081111115227.GU26778@kernel.dk> <4919B884.5000604@telenet.dn.ua> <20081111180659.GC26778@kernel.dk> <x49vduunjh4.fsf@segfault.boston.devel.redhat.com> <20081111164104.48f4dbd8@tleilax.poochiereds.net> <20081111165931.6f98401b@tleilax.poochiereds.net> <20081112122033.GO26778@kernel.dk> <20081112074503.47e175ae@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112074503.47e175ae@tleilax.poochiereds.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 07:45:03AM -0500, Jeff Layton wrote:
> Ahh Good point...I wasn't thinking about it the right way. I guess what
> we really need is some way to tell that a series of I/O requests
> originated from the same client thread. NFS isn't really conducive to
> this...
> 
> We might be able to do something like that with NFSv4 though. Maybe an
> io_context per state owner or something. That's probably not going to
> be trivial to implement however...

Talk to Greg Banks, he's been thinking about and working on an open
files cache for quite a while already.

