Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbYBFTmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbYBFTmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758867AbYBFTmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:42:12 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:62492 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758845AbYBFTmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:42:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=t6X+6LBMRLMrOTvzVyTaslewaqiJvTZLGVLs7Z6pzhVv7hThp8pjZ3nJooByV+bYdDizpEn4k+U1W6OU/RxQLc40K4Bjp9+D5OTjRbnjuYQrSVLFVH1aixTl5f1SVloUggUvwMUUkAcANpgyFDZQAU7XJ01lvgUpxicx0AOxIOo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: feature-removal-schedule.txt is getting out of date again
Date: Wed, 6 Feb 2008 20:54:59 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
References: <alpine.LFD.1.00.0802060419140.17178@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.00.0802060419140.17178@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802062054.59755.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 06 February 2008, Robert P. J. Day wrote:
> 
>   yes, i realize i'm sounding like a broken record but, once again,
> Documentation/feature-removal-schedule.txt is slipping out of date WRT
> items that are now slightly, if not noticeably, behind schedule for
> removal.

IIRC I saw few patches addressing some items but they are not yet Linus'
tree, i.e. old mxser driver removal:

http://lkml.org/lkml/2008/1/18/235

Jiri, I see that old mxser removal has been on removal list for a long time
and that Alan has reviewed the whole patch series (+ all patches look good
for me from quick skimming through them).  It also has been in the last -mm
release.  Because we are going to hit 2.6.25-rc1 quite soon I think that
this patch series should find its way into Linus' tree

Andrew, are you going to push it soon (or maybe Jiri should prepare git tree
and send Linus a pull request)?

Robert, I suggest that you just send patches removing outdated items (probably
starting with the one below like you tried in the past) and be quite stubborn
about it (otherwise you can be pretty sure that nothing will happen)...

...
What:   PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
When:   November 2005
....

http://lkml.org/lkml/2007/5/1/107

Christoph, 10 months later and this method doesn't seem to work.

How's about disabling it in -mm and waiting for complaints instead
(if none come just remove the code in 2.6.26-rc1)?

[ Either this or we should just remove the item in question from
  feature-removal-schedule.txt. ]

Thanks,
Bart
