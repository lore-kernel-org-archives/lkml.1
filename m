Return-Path: <linux-kernel-owner+w=401wt.eu-S1761968AbXIKWrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761968AbXIKWrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 18:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758316AbXIKWr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 18:47:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756938AbXIKWrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 18:47:25 -0400
Date: Tue, 11 Sep 2007 15:46:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: patrizio.bassi@gmail.com
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Kernel," <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Andi Kleen <ak@suse.de>,
       linux-acpi@vger.kernel.org
Subject: Re: libata not working for sis5533
Message-Id: <20070911154658.ab1fe162.akpm@linux-foundation.org>
In-Reply-To: <46E3DA7E.7060709@gmail.com>
References: <46D132C5.5000803@gmail.com>
	<6bffcb0e0708261627s12e5a9acqef92d0261264a40c@mail.gmail.com>
	<46D8921E.3010304@gmail.com>
	<46D89429.7080802@gmail.com>
	<20070902114032.7dbfb21a@the-village.bc.nu>
	<Pine.LNX.4.64.0709031957390.24179@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0709061156220.25942@fbirervta.pbzchgretzou.qr>
	<46E26DAF.9020906@gmail.com>
	<Pine.LNX.4.64.0709081243050.25942@fbirervta.pbzchgretzou.qr>
	<46E3DA7E.7060709@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Sep 2007 13:35:26 +0200
Patrizio Bassi <patrizio.bassi@gmail.com> wrote:

> Patrizio Bassi ha scritto:
> > Jan Engelhardt ha scritto:
> >> On Sep 8 2007 11:38, Patrizio Bassi wrote:
> >>  
> >>> Jan Engelhardt wrote:
> >>>    
> >>>> I shall give this a spin too, since I happen to have sis5513.
> >>>>
> >>>> Just booted this fresh ata-enabled system (a matter of mkinitrd).
> It has
> >>>> not exploded yet.
> >>>>      
> >>> don't you have the "irq 14" issue?
> >>>    
> >> No, does not seem so.
> >>
> >>  
> >>> can you post here your .config?
> >>>    
> >> http://rafb.net/p/vfTX0966.html
> >>
> >> Maybe it is solved in 2.6.22.3? (I don't remember what your version
> >> was.)
> >>
> >>
> >>     Jan
> >>  
> >
> > For Alan, libata devs...hope can help debug...
> > this is http://www.patriziobassi.it/downloads/libata_issue.jpg

Looks more like a platform irq routing issue than an ata issue.

Perhaps an x86 or an acpi person can help out with this.

Probably nothing will happen, in which case I'll get back to you later
and ask you to raise a bugzilla entry, not that this will get it fixed :(


> > and this is the relative config i'm using
> > http://www.patriziobassi.it/downloads/config
> >
> > Let me know
> >
> > Patrizio
> 
> more debug:
> 
> I tried as suggested with the irqpoll option, i just get a faster panic
> as i don't have the 3 xfermode lines...but always impossibile to boot...
> 
> Patrizio
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
