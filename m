Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZG3Kkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZG3Kkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 06:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbZG3Kkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 06:40:45 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:53464 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbZG3Kkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 06:40:43 -0400
Date: Thu, 30 Jul 2009 12:40:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Message-ID: <20090730104041.GA23926@merkur.ravnborg.org>
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site> <20090729162844.GA22561@merkur.ravnborg.org> <1248885456.3900.48.camel@mulgrave.site> <4A7166A3.70509@panasas.com> <20090730093403.GA11381@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090730093403.GA11381@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 12:34:03PM +0300, Michael S. Tsirkin wrote:
> On Thu, Jul 30, 2009 at 12:23:47PM +0300, Boaz Harrosh wrote:
> > >> I did a quick diff of the glibc provided scsi.h and kernel scsi.h.
> > >> >From a quick look it seems that we have more in the kernel version
> > >> than the glibc version - and no obvious conflicts.
> > >>
> > 
> > exactly it is original Kernel headers from the time they where sampled
> > last by glibc.
> 
> glibc also added
> #include <features.h>
> in some of them.
> Donnu why.

Browsing features.h this looked unused (by scsi.h) to me.

	Sam
