Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbYHEXwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbYHEXwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbYHEXwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:52:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756498AbYHEXwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:52:00 -0400
Date: Tue, 5 Aug 2008 16:51:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Adrian Bunk <bunk@kernel.org>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] feature-removal-schedule.txt: remove the NCR53C9x
 entry
Message-Id: <20080805165110.f0991143.akpm@linux-foundation.org>
In-Reply-To: <20080805233718.GB2514@lst.de>
References: <20080805200330.GJ22895@cs181140183.pp.htv.fi>
	<20080805233718.GB2514@lst.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 01:37:19 +0200 Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Aug 05, 2008 at 11:03:30PM +0300, Adrian Bunk wrote:
> > Now that the driver is removed we should also remove the entry in 
> > Documentation/feature-removal-schedule.txt
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > Acked-by: Christoph Hellwig <hch@lst.de>
> > 
> > ---
> > 
> > This patch has been sent on:
> > - 1 Mar 2008
> > 
> > 6d7882f6e844eaf6551b3a3708e01d1784916435 foobar
> > diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> > index c1d1fd0..a4530f0 100644
> > --- a/Documentation/feature-removal-schedule.txt
> > +++ b/Documentation/feature-removal-schedule.txt
> > @@ -19,15 +19,6 @@ Who:	Pavel Machek <pavel@suse.cz>
> >  
> >  ---------------------------
> >  
> > -What:	old NCR53C9x driver
> > -When:	October 2007
> > -Why:	Replaced by the much better esp_scsi driver.  Actual low-level
> > -	driver can be ported over almost trivially.
> > -Who:	David Miller <davem@davemloft.net>
> > -	Christoph Hellwig <hch@lst.de>
> > -
> > ----------------------------
> > -
> >  What:	Video4Linux API 1 ioctls and video_decoder.h from Video devices.
> >  When:	December 2008
> >  Files:	include/linux/video_decoder.h include/linux/videodev.h
> ---end quoted text---
>

(pop toasting repaired)

> This should really be easy enough for any merge window state, whoe wants
> to feed it to Linus?
> 

I have it queued for my next Linuswards batch.  I tend to push
non-code-related changes immediately.

