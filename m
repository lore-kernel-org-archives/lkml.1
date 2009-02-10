Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbZBJKx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbZBJKx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 05:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbZBJKxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 05:53:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:18186 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbZBJKxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 05:53:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Bo7/Z8oVDPSkN1isN3dQam6pNcocg6f1pLjuTlcFhvrtPEq5UQ1XJIGv2qZKNjHveI
         8LkKytwmEt28QF8Qg92440pDNW51VF3FYa4vZuAbCjKyHcp3W1t1ZFXnygaoaBs9M9yn
         o5aTDenuU+U5O9yUT6114M7sR6MjZSM5dwdhE=
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
From: Alessandro Bono <alessandro.bono@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@oss.sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090210104304.GP8830@disturbed>
References: <1234011974.7435.11.camel@champagne.cantina>
	 <20090208222859.GA2532@infradead.org>
	 <1234132752.12370.0.camel@champagne.cantina>
	 <20090208224249.GA11931@infradead.org>
	 <1234133120.12370.7.camel@champagne.cantina>
	 <20090209075308.GA7360@infradead.org>  <20090210104304.GP8830@disturbed>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 11:53:14 +0100
Message-Id: <1234263194.7462.8.camel@champagne.cantina>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 21:43 +1100, Dave Chinner wrote:
> On Mon, Feb 09, 2009 at 02:53:08AM -0500, Christoph Hellwig wrote:
> > On Sun, Feb 08, 2009 at 11:45:20PM +0100, Alessandro Bono wrote:
> > > sure, attached
> > 
> > That would be a missing PagePrivate bit in page_buffers() called from
> > end_buffer_async_write.  PG_private can only be cleared via drop_buffers
> > which requires the page not having PG_writeback set which must be
> > set until end_buffer_async_write is done.  Very strange, and all this
> > is generic code without xfs involvement.  Did this happen once
> > or can you reproduce it?
> 
> Hmmmm - i wonder if this has anything to do with the writeback fixes
> that went into 2.6.28.2? Alessandro, can you revert to 2.6.28.1 (not
> plain 2.6.28) and see if you can reproduce the problem?

no problem 
I'll try with 2.6.28.1 a full rsync (circa 210G)
maybe I can do this today


> 
> Cheers,
> 
> Dave.
-- 
---
Cordiali Saluti
Alessandro Bono

