Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbXIJJDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbXIJJDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbXIJJDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:03:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56364 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbXIJJDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:03:09 -0400
Date: Mon, 10 Sep 2007 02:02:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nigel Kukard <nkukard@lbsd.net>
Cc: Dave Jones <davej@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: SATA problems
Message-Id: <20070910020243.1101cf7a.akpm@linux-foundation.org>
In-Reply-To: <46D68CC2.3030206@lbsd.net>
References: <4671366B.7090702@lbsd.net>
	<46716B1D.1070902@garzik.org>
	<20070614182854.GC1223@redhat.com>
	<20070618200703.GB13344@redhat.com>
	<46776223.3050402@lbsd.net>
	<46D68CC2.3030206@lbsd.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007 09:24:18 +0000 Nigel Kukard <nkukard@lbsd.net> wrote:

> Hrmmm,
> 
> >>  > 
> >>  >  > > Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on port
> >>  >  > > 0x0001c807
> >>  >  > > Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on port
> >>  >  > > 0x0001c807
> >>  > 
> >>  > Unrelated to the other error, but I've been meaning to ask for a while..
> >>  > If this is 'abnormal', why does every SATA box I've seen do it?
> >>
> >> *crickets*

chirp, chirp.

> >> Should we check for this case explicitly, and not print this?
> >>
> >>   
> >>     
> > After I get the above errors, my entire SATA bus crashes and I need to
> > hard reset the box ... not sure we can just ignore the errors?
> >
> >   
> 
> Appears even with the patch provided a few months ago I'm getting
> freezes. Replaced the HDD & all cables, same errors ... especially
> whilst doing heavy IO.
> 
> Can anyone shed some light?
> 

I think I was told last week that copying the appropriate mailing list will
at least prevent chirping, so let's try that.

Original thread here: http://lkml.org/lkml/2007/6/14/154

> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd c8/00:00:9f:c9:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
> 131072 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ATA: abnormal status 0x7F on port 0x0001c807
> ATA: abnormal status 0x7F on port 0x0001c807
> ata2.00: configured for UDMA/133
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd c8/00:00:9f:c9:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
> 131072 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ATA: abnormal status 0x7F on port 0x0001c807
> ATA: abnormal status 0x7F on port 0x0001c807
> ata2.00: configured for UDMA/133
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd c8/00:00:9f:c9:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
> 131072 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ATA: abnormal status 0x7F on port 0x0001c807
> ATA: abnormal status 0x7F on port 0x0001c807
> ata2.00: configured for UDMA/133
> ata2: EH complete
> ata2.00: limiting speed to UDMA/100:PIO4
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd c8/00:00:9f:c9:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
> 131072 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ATA: abnormal status 0x7F on port 0x0001c807
> ATA: abnormal status 0x7F on port 0x0001c807
> ata2.00: configured for UDMA/100
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd c8/00:00:9f:c9:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
> 131072 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ATA: abnormal status 0x7F on port 0x0001c807
> ATA: abnormal status 0x7F on port 0x0001c807
> ata2.00: configured for UDMA/100
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd c8/00:00:9f:c9:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
> 131072 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ATA: abnormal status 0x7F on port 0x0001c807
> ATA: abnormal status 0x7F on port 0x0001c807
> ata2.00: configured for UDMA/100
> sd 3:0:0:0: SCSI error: return code = 0x08000002
> sda: Current [descriptor]: sense key=0xb
>     ASC=0x0 ASCQ=0x0
> Descriptor sense data with sense descriptors (in hex):
>         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
>         00 00 00 00
> end_request: I/O error, dev sda, sector 30132639
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd c8/00:00:9f:ca:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
> 131072 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ATA: abnormal status 0x7F on port 0x0001c807
> ATA: abnormal status 0x7F on port 0x0001c807
> ata2.00: configured for UDMA/100
> ata2: EH complete
> ata2.00: limiting speed to UDMA/33:PIO4
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd c8/00:00:9f:ca:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
> 131072 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ATA: abnormal status 0x7F on port 0x0001c807
> ATA: abnormal status 0x7F on port 0x0001c807
> ata2.00: configured for UDMA/33
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd c8/00:00:9f:ca:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
> 131072 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ATA: abnormal status 0x7F on port 0x0001c807
> ATA: abnormal status 0x7F on port 0x0001c807
> ata2.00: configured for UDMA/33
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd c8/00:00:9f:ca:cb/00:00:00:00:00/e1 tag 0 cdb 0x0 data
> 131072 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ATA: abnormal status 0x7F on port 0x0001c807
> ATA: abnormal status 0x7F on port 0x0001c807
> ata2.00: configured for UDMA/33
> ata2: EH complete
> 
> 
> 
