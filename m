Return-Path: <linux-kernel-owner+w=401wt.eu-S1764000AbXJSNws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764000AbXJSNws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 09:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbXJSNwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 09:52:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:20186 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507AbXJSNwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 09:52:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qZX0b5SNTE7yNfSOUTdn9diZdgeTSQNT3a0JmzSUd0/ygKAhAU1dFxCKv+M/dxxmd68YvXEr35icO5B2mnpqjeKt8r1K1j/ZtfIahygs0MQhjTJ2LLdwDDBwoPXQdat3McPo+OGOeYeikVLN3Cg4aSUBtX78itEynfCUcaK74QY=
Message-ID: <5501535d0710190652i38fe374cx9967d5d7d265eac2@mail.gmail.com>
Date: Fri, 19 Oct 2007 15:52:36 +0200
From: "Bjoern Olausson" <lkmlist@gmail.com>
To: "Paul Rolland" <rol@as2917.net>
Subject: Re: [2.6.22.5] irq X: nobody cared but X is successfully used by libata
Cc: linux-kernel@vger.kernel.org,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
In-Reply-To: <20071019141421.5a13e90c@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070826203513.4fa35f68@tux.DEF.witbe.net>
	 <6bffcb0e0708261637s3369dd6fl1f833461e41c4daa@mail.gmail.com>
	 <47182323.10706@gmail.com> <20071019141421.5a13e90c@tux.DEF.witbe.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/07, Paul Rolland <rol@as2917.net> wrote:
> Hi Tejun,
>
> On Fri, 19 Oct 2007 12:23:15 +0900
> Tejun Heo <htejun@gmail.com> wrote:
>
> > > On 26/08/07, Paul Rolland <rol@as2917.net> wrote:
> > >> My machine (an ASUS P5W-DH-Deluxe, Core2, 4Go RAM, 3 SATA and 2IDE) is
> > >> reporting a :
> > >> irq 23: nobody cared (try booting with the "irqpoll" option)
> > >> together with a Call Trace, but :
> > >>  - irqpoll is present on the command line,
> > >>  - the irq is reported to be used by libata,
> > >>  - the irqpoll option is mandatory if I want _some_ of my SATA disks to
> > >> be accessible.
> >
> > Does this still happen with 2.6.23?  If so, please post boot log.  Thanks.
> >
> Not tested yet, will do so during the WE.
>
> Regards,
> Paul

No it does not.

I have nearly the same setup (ASUS P5W-DH-Deluxe, Core2, 2GB RAM, 3
SATA and 2IDE)

And a "dmesg | grep irqpoll does not show up with results.

dmsg | grep 23 comes up with:
wifi0: Atheros 5212: mem=0xeb9f0000, irq=23

And I no longer use IRQPOLL (I dropped it somwhere between 2.6.22.?
and 2.6.23) as Kernel option.
kernel (hd0,0)/vmlinuz root=/dev/sda3 video=nvidiafb:1280x1024-32@85,mtrr,ywrap

All SATA Ports are working (except the the PMP... it "works" but I
would not recomment usign it right now because of these bugs:
http://bugzilla.kernel.org/show_bug.cgi?id=9010
http://bugzilla.kernel.org/show_bug.cgi?id=9010

regards
Bjoern Olausson
