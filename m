Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYKKRLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYKKRLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbYKKRLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:11:25 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:12642 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468AbYKKRLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:11:24 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgYBAAtKGUlR9Vw5/2dsb2JhbAAIzTuDVw
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH] Video/UVC: Fix unaligned exceptions in uvc video driver.
Date: Tue, 11 Nov 2008 18:11:34 +0100
User-Agent: KMail/1.9.9
Cc: "Bryan Wu" <cooloney@kernel.org>, linux-uvc-devel@lists.berlios.de,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
References: <1225963052-6657-1-git-send-email-cooloney@kernel.org> <200811091355.05074.laurent.pinchart@skynet.be> <8A42379416420646B9BFAC9682273B6D065BA534@limkexm3.ad.analog.com>
In-Reply-To: <8A42379416420646B9BFAC9682273B6D065BA534@limkexm3.ad.analog.com>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811111811.35098.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 November 2008, Hennerich, Michael wrote:
> > -----Original Message-----
> > From: Laurent Pinchart [mailto:laurent.pinchart@skynet.be]
> > Sent: Sunday, November 09, 2008 1:55 PM
> > To: Bryan Wu
> > Cc: linux-uvc-devel@lists.berlios.de; video4linux-list@redhat.com;
> > linux-kernel@vger.kernel.org; Michael Hennerich
> > Subject: Re: [PATCH] Video/UVC: Fix unaligned exceptions in uvc video
> > driver.
> >
> > Hi Bryan, Michael,
> >
> > Thanks for the patch.
> >
> > On Thursday 06 November 2008, Bryan Wu wrote:
> > > From: Michael Hennerich <michael.hennerich@analog.com>
> > >
> > > buffer can be odd aligned on some NOMMU machine such as Blackfin
> >
> > The comment is a bit misleading. Buffers can be odd-aligned independently
> > off the machine type. The issue comes from machines that can't access
> > unaligned memory. Something like "Fix access to unaligned memory" would be
> > better.
[snip]

> > What about using get_unaligned_le16 and get_unaligned_le32 directly ?
> > Lines would be shorter and could be kept behind the 80 columns limit more
> > easily.
> > Tell me if you want to resubmit or if I should make the modification
> > myself (including the patch description).
>
> Laurent,
>
> Well - I just used the same style already used in various other places
> in the uvc driver. - Just wanted to be consistent.

No worries. get_unaligned_le{16|32} has been introduced in the kernel recently 
and I haven't updated the uvcvideo driver like I should have. I'll fix that.

> If you don't mind doing the changes (including the patch description),
> please go ahead.

Ok I'll fix and submit the patch.

Best regards,

Laurent Pinchart
