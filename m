Return-Path: <linux-kernel-owner+w=401wt.eu-S1030380AbXBTTvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030380AbXBTTvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 14:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030381AbXBTTvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 14:51:39 -0500
Received: from smtp.bulldogdsl.com ([212.158.248.8]:1667 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030380AbXBTTvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 14:51:38 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Subject: Re: PCI riser cards and PCI irq routing, etc
Date: Tue, 20 Feb 2007 19:51:32 +0000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
References: <45D85DA1.7090502@xs4all.nl> <200702201456.30794.s0348365@sms.ed.ac.uk> <45DB174F.30708@xs4all.nl>
In-Reply-To: <45DB174F.30708@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702201951.32521.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 February 2007 15:44, you wrote:
> Alistair John Strachan wrote:
> > On Tuesday 20 February 2007 04:17, Udo van den Heuvel wrote:
> >> Krzysztof Halasa wrote:
> >>> Is it a VIA ITX board? I think I have VIA's riser card somewhere,
> >>> could check what it does.
> >>
> >> Yes, VIA Epia EN12000.
> >> Interesting to check the riser card.
> >
> > Just be aware that there are two types of PCI riser -- risers that work
> > in any board, and Via Epia-specific risers. The latter requires a BIOS
> > update on some Epias and presumably has some advantages, possible the
> > ones you're looking for.
>
> This card is sold by TranquilPC for their T2e case which holds Mini-ITX
> boards. My EN12000 has the latest BIOS I could find on the VIA site:
> http://www.via.com.tw/en/products/mainboards/downloads.jsp?motherboard_id=3
>99#BIOS

The riser I have here is called "ext-pci rev b" and is marked "Via Tech Inc". 
My understanding is that this is not an "active riser" and requires explicit 
BIOS support.

A quick googling for the device revealed this:

http://forums.viaarena.com/messageview.aspx?catid=32&threadid=41622&highlight_key=y&keyword1=riser

A poster here seems to suggest the following:

"As far as I know the only dual riser card that is supported by the EPIA BIOS 
is the one from VIA (that faces out). That one has some logic on it to get 
both slots working. The upper slot uses device 19 and INT_A, allocated 
through the EPIA BIOS."

This may perhaps describe the issue you are having, and from the PDF you 
linked I do not believe you have a riser that is the same as mine.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
