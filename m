Return-Path: <linux-kernel-owner+w=401wt.eu-S1761167AbXFSS3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167AbXFSS3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759073AbXFSS2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:28:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:2880 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594AbXFSS2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:28:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=U2Zsgepl5hH5uG8xgnPAssa7kvGSC7shkhq36i7VT5ihrnFM5UuS8wLZxK8rxsLlMz9nCNF5rneVIaZbqhTok1aCu4okWXZ4qCn0378wjGG9ROzLvX5kVxrxJ0iHQTDUzeF+ZjdbDnyMV2vJ/ku5OfeT2n5iXq+lzWMs/JJ01yM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linas Vepstas <linas@austin.ibm.com>
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
Date: Tue, 19 Jun 2007 20:43:40 +0200
User-Agent: KMail/1.9.6
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Stuart_Hayes@dell.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070618175713.GD5836@austin.ibm.com> <4677FFF1.2010308@ru.mvista.com> <20070619164854.GR5836@austin.ibm.com>
In-Reply-To: <20070619164854.GR5836@austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706192043.40298.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 19 June 2007, Linas Vepstas wrote:
> On Tue, Jun 19, 2007 at 08:10:25PM +0400, Sergei Shtylyov wrote:
> > 
> > >I'm thinking that trying to debug libata is a better idea, rather than
> > >investing time in ide, right?  Although at the moment, libata works even 
> > >less; see other email.
> > 
> >    Which makes me think this really is some *hardware* issue.

Linas, have you checked that there are no firmware updates available
for this drive?

> There are two distinct issues.
> -- libata locks up in partition table read on an hpt366+old maxtor disk
>    that has ben working fine for many years with old ide driver. (It
>    still works fine when I boot to the alternate ide-based kernel).
> 
> -- ide driver locks up on hpt366+new maxtor disk under heavy 
>    i/o load. I was able to copy 60GB from old to new disk without a
>    problem; however, raid reconstruction locks it up, maybe after 5-15
>    seconds.
> 
>    This probably is "hardware related"; its something that the new 
>    hard drive does. Given that its being sold at a big discount, it
>    may even be that the sellers know that this is a crappy disk. :-)
> 
>    All I want is some way of resetting the disk, and continuing on.

It would be useful to see hdparm --Istdout output for *both* disks.

> I'm stalled in debugging; I'm not sue what I'm looking for.

Sergei, do you think that testing the drive with DMA disabled may
tell us something new?

Thanks,
Bart
