Return-Path: <linux-kernel-owner+w=401wt.eu-S1761840AbYBHDQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761840AbYBHDQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 22:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbYBHDQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 22:16:47 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54761 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756565AbYBHDQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 22:16:46 -0500
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, dougg@torque.net
In-Reply-To: <20080207184606.03b28a9c.akpm@linux-foundation.org>
References: <1202432206.3171.53.camel@localhost.localdomain>
	 <20080207184606.03b28a9c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 21:16:43 -0600
Message-Id: <1202440603.3171.72.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-07 at 18:46 -0800, Andrew Morton wrote:
> On Thu, 07 Feb 2008 18:56:46 -0600 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > Quite a bit of this is fixing things broken previously (the advansys fix
> > is still pending resolution, but I'll send it as an -rc fix when we have
> > it).  There's the final elimination of all drivers that are esp based
> > but don't use the scsi_esp core (that's mostly m68k and alpha).  Plus
> > the usual bunch of driver updates and the addition of a new enclosure
> > services driver and the corresponding ULD.
> 
> Sob.  Can we please merge "Convert SG from nopage to fault"?  It has been
> sent three times, the first time was Dec 5 last year and it has thus far
> received the lead balloon treatment.  Despite my explicit request for
> consideration last time I sent it
> 
> If there is no movement here then I have to carry the moderately intrusive
> mm-remove-nopage.patch for another N months and we need to watch out for
> new ->nopage implementations popping up etc.

I agree ... I've pinged Doug privately, this is publicly.
Unfortunately, it is an intrusive change and needs testing .. I just
don't have the tools that do this for SG.  

James


