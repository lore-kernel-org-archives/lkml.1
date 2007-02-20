Return-Path: <linux-kernel-owner+w=401wt.eu-S964969AbXBTO4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964969AbXBTO4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964970AbXBTO4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:56:36 -0500
Received: from mcr-smtp-001.bulldogdsl.com ([212.158.248.7]:3870 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964969AbXBTO4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:56:35 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Subject: Re: PCI riser cards and PCI irq routing, etc
Date: Tue, 20 Feb 2007 14:56:30 +0000
User-Agent: KMail/1.9.5
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
References: <45D85DA1.7090502@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain> <45DA7643.4020305@xs4all.nl>
In-Reply-To: <45DA7643.4020305@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702201456.30794.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 February 2007 04:17, Udo van den Heuvel wrote:
> Krzysztof Halasa wrote:
> > Udo van den Heuvel <udovdh@xs4all.nl> writes:
> >> At the bottom I added a dmesg output of the kernel after boot.
> >> I more or less know that irq 20 for the DVB-S card (saa7146 (1)) is
> >> 'working'. I know that irq 16 for saa7146 (0) (DVB-T) is not working for
> >> i2c although the card does work perfectly for DVB-T reception (picture,
> >> low CPU load, etc) with only reception as the bottleneck.
> >
> > BTW: Can you check which device # and IRQ does the card get if plugged
> > directly into the PCI slot on board (without the riser)?
>
> DN is 20 I believe (from the tranquilPC doc).
> irq I'd have to check.
>
> > Is it a VIA ITX board? I think I have VIA's riser card somewhere,
> > could check what it does.
>
> Yes, VIA Epia EN12000.
> Interesting to check the riser card.

Just be aware that there are two types of PCI riser -- risers that work in any 
board, and Via Epia-specific risers. The latter requires a BIOS update on 
some Epias and presumably has some advantages, possible the ones you're 
looking for.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
