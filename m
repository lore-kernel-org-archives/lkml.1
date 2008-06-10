Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbYFJStS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbYFJStS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYFJStD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:49:03 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:59973 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbYFJStA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:49:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=JOmEOYJz2gehs7y23IJBax6ARlS//YXca34o4r85fnFsvQWwPiIRv2k/e99cRBrddo
         MO4XGeJAK1JDFzFdhJ1Yo8qqoyU5SNF8fevGiAKl4uwynFNFgpj/nZXnT1Sp3a9AToOK
         MICwwpzN9js2fnSwDJPwKwavzbE/IIyUJkgdU=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: "Grant Grundler" <grundler@google.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Tue, 10 Jun 2008 18:46:24 +0000
User-Agent: KMail/1.9.9
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       "Hannes Reinecke" <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200806010415.05290.chris2553@googlemail.com> <200806061735.35268.chris2553@googlemail.com> <da824cf30806082151n12898443p1a780a431e99712f@mail.gmail.com>
In-Reply-To: <da824cf30806082151n12898443p1a780a431e99712f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101846.24650.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 June 2008, Grant Grundler wrote:
> On Fri, Jun 6, 2008 at 10:35 AM, Chris Clayton <chris2553@googlemail.com> 
wrote:
> >...
> > Yes, I still get the boot pause and the delay in desktop icons appearing
> > when a usb-storage device is plugged in with -rc5. A boot log is
> > attached. Is there some sort of verbose scsi boot messaging that I can
> > switch on? I've looked but I'm damned if I can find anything in 'make
> > menuconfig'.
>
> SCSI_CONSTANTS and SCSI_LOGGING might help.
> Both live in the SCSI options menu. Read the Kconfig help on how
> to use SCSI_LOGGING.
>
> Can you please also enable CONFIG_PRINTK_TIME ?

I've enabled CONFIG_PRINTK_TIME and will look into the SCSI options.

Thanks
>
> Using the timestamps in /var/log/messages is ok but not the most
> reliable place to get somewhat accurate time stamps of events.
>
> hth,
> grant



-- 
Beauty is in the eye of the beerholder.
