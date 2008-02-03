Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYBCUPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYBCUPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 15:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYBCUPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 15:15:11 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48921 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762AbYBCUPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 15:15:09 -0500
Subject: Re: [patch] scsi: fix spurious build failures in aic7xxx
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Hannes Reinecke <hare@suse.de>,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <20080203200558.GC2648@uranus.ravnborg.org>
References: <20080201225056.GA18302@elte.hu>
	 <20080202135935.GA23838@uranus.ravnborg.org>
	 <20080202140326.GA6544@elte.hu> <20080202140630.GA7939@elte.hu>
	 <20080202141857.GA8635@elte.hu>
	 <20080202162611.GA24765@uranus.ravnborg.org>
	 <20080202171020.GB12748@elte.hu> <20080203045441.GA12128@elte.hu>
	 <20080203074143.GA19981@uranus.ravnborg.org>
	 <1202066623.3318.95.camel@localhost.localdomain>
	 <20080203200558.GC2648@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 03 Feb 2008 14:15:00 -0600
Message-Id: <1202069700.3318.100.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-02-03 at 21:05 +0100, Sam Ravnborg wrote:
> On Sun, Feb 03, 2008 at 01:23:42PM -0600, James Bottomley wrote:
> > On Sun, 2008-02-03 at 02:41 -0500, Sam Ravnborg wrote:
> > >         Thanks for testing Ingo.
> > >         
> > >         James - I plan to submit this via kbuild.git in about 10
> > >         hours.
> > >         Let me know if you would like it to go in via scsi and I
> > >         will drop you an updated patch (need to elaboarte a bit more
> > >         in
> > >         the commit message).
> > 
> > Sure, the changes look fine .. and will not conflict with anything
> > pending I currently have.  You can add my acked-by if you want.
> Thanks - will do so.

Great

> > 
> > Please also note the @steeleye.com email address doesn't come to me any
> > more, so this email had to be forwarded.
> OK.
> Can I ask you to fix these:
> Documentation/DocBook/scsi.tmpl:            <email>James.Bottomley@steeleye.com</email>
> Documentation/scsi/scsi_mid_low_api.txt:        James Bottomley <James dot Bottomley at steeleye dot com>

Sure, I'll patch those

> drivers/base/attribute_container.c: * Copyright (c) 2005 - James Bottomley <James.Bottomley@steeleye.com>
> drivers/base/transport_class.c: * Copyright (c) 2005 - James Bottomley <James.Bottomley@steeleye.com>
> drivers/scsi/raid_class.c: * Copyright (c) 2005 - James Bottomley <James.Bottomley@steeleye.com>
> include/linux/attribute_container.h: * Copyright (c) 2005 - James Bottomley <James.Bottomley@steeleye.com>
> include/linux/raid_class.h: * Copyright (c) 2005 - James Bottomley <James.Bottomley@steeleye.com>
> include/linux/transport_class.h: * Copyright (c) 2005 - James Bottomley <James.Bottomley@steeleye.com>

This is less obvious:  The copyrights are historical rather than current
and also, I was at steeleye when I did that work, so it does deserve to
be reflected in the file history.  I know it adds confusion from a whom
do I contact for this file point of view, but it is legally the right
thing to do.

James


