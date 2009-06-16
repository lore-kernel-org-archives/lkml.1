Return-Path: <linux-kernel-owner+w=401wt.eu-S1763515AbZFPVa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763515AbZFPVa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763245AbZFPV37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:29:59 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:47766 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762875AbZFPV36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:29:58 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: Greg KH <gregkh@suse.de>
Subject: Re: staging driver s626 clashes with philips SAA7146 media/dvb based cards
Date: Tue, 16 Jun 2009 18:30:01 -0300
User-Agent: KMail/1.11.90 (Linux/2.6.30-desktop-1mnb; KDE/4.2.90; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Gianluca Palli <gpalli@deis.unibo.it>,
       David Schleef <ds@schleef.org>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <abbotti@mev.co.uk>
References: <200906161701.45234.herton@mandriva.com.br> <20090616205121.GB2810@suse.de>
In-Reply-To: <20090616205121.GB2810@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200906161830.02308.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Terça-feira 16 Junho 2009, às 17:51:21, Greg KH escreveu:
> On Tue, Jun 16, 2009 at 05:01:44PM -0300, Herton Ronaldo Krzesinski wrote:
> > Hi,
> >
> > The s626 (comedi) driver in staging conflicts with philips SAA7146
> > media/dvb based cards, because it claims the same vendor:device pci id
> > for all subdevice/subvendor ids. What happens is that for people that
> > have a philips SAA7146 based card, s626 if available gets loaded by udev
> > and makes system freeze (https://qa.mandriva.com/show_bug.cgi?id=51445).
>
> So a PCI device that does different things has the same device ids?
> ick, stupid vendors...
>
> > Looks like s626 shouldn't claim all 1131:7146 devices, either by
> > specifying specific subdevice/subvendor ids specific to s626 devices or
> > doing additional checks in its probe/attach function.
>
> If you can propose the proper sub ids, or the needed checks, please send
> a patch.

Can't propose proper sub ids here etc., as I don't know about/don't have s626 
device, s626 author is CC'ed here to check this. But I could send a patch to 
disable just the build of s626 if acceptable/desired for the moment.

>
> thanks,
>
> greg k-h

--
[]'s
Herton
