Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbXIBV0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbXIBV0E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 17:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbXIBVZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 17:25:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56474 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXIBVZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 17:25:52 -0400
Date: Mon, 3 Sep 2007 03:08:58 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Alistair John Strachan <alistair@devzero.co.uk>
cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Winischhofer <thomas@winischhofer.net>,
       Greg Kroah-Hartman <greg@kroah.com>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH -mm] sisusbvga: Fix bug and build warnings
In-Reply-To: <200709022218.06849.alistair@devzero.co.uk>
Message-ID: <alpine.LFD.0.999.0709030305030.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
 <alpine.LFD.0.999.0709030159320.29617@enigma.security.iitk.ac.in>
 <9a8748490709021323k3d4adbddv53346aacdd66ab57@mail.gmail.com>
 <200709022218.06849.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-1262612648-1188768980=:29617"
Content-ID: <alpine.LFD.0.999.0709030307031.29617@enigma.security.iitk.ac.in>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-1262612648-1188768980=:29617
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.0.999.0709030307032.29617@enigma.security.iitk.ac.in>



On Sun, 2 Sep 2007, Alistair John Strachan wrote:

> On Sunday 02 September 2007 21:23:16 Jesper Juhl wrote:
> > On 02/09/07, Satyam Sharma <satyam@infradead.org> wrote:
> > > Hi Jesper,
> > >
> > > On Sun, 2 Sep 2007, Jesper Juhl wrote:
> > > > > -       if (!(interface = usb_find_interface(&sisusb_driver,
> > > > > subminor))) { -               dev_err(&sisusb->sisusb_dev->dev,
> > > > > "Failed to find interface¥n");
> > > >
> > > > Odd how in your patch the line ends with  "¥n"  but if I look in my
> > > > local copy of the source tree I see  "\n".
> > >
> > > Odd, indeed. I see correct '\n' in the mail I sent, but in your mail
> > > here it's coming out wrong -- lkml.org shows badness as well. Hmmm,
> > > "insert file" using ^R in alpine never gave any problems before ...
> 
> The encoding is set to ISO-2022-JP, this is probably breaking things.

??? I have no clue how/why/when that suddenly happened.

I clearly see "Content-Type: TEXT/PLAIN; charset=us-ascii" for the first
mail I sent out -- but all the replies seem to have somehow got this
weirdness. Will close and restart my alpine session, just in case ...
thanks for heads-up, Alistair.
--464262402-1262612648-1188768980=:29617--
