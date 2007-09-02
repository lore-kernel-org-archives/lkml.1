Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbXIBUTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbXIBUTt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbXIBUTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:19:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56380 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbXIBUTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:19:40 -0400
Date: Mon, 3 Sep 2007 02:02:47 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Winischhofer <thomas@winischhofer.net>,
       Greg Kroah-Hartman <greg@kroah.com>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH -mm] sisusbvga: Fix bug and build warnings
In-Reply-To: <9a8748490709021311q179ab8c6iee7ffb14f6a2eb80@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0709030159320.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
  <alpine.LFD.0.999.0709030136140.29617@enigma.security.iitk.ac.in>
 <9a8748490709021311q179ab8c6iee7ffb14f6a2eb80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-428625364-1188765171=:29617"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-428625364-1188765171=:29617
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT

Hi Jesper,


On Sun, 2 Sep 2007, Jesper Juhl wrote:
> 
> > -       if (!(interface = usb_find_interface(&sisusb_driver, subminor))) {
> > -               dev_err(&sisusb->sisusb_dev->dev, "Failed to find interface¥n");
> 
> Odd how in your patch the line ends with  "¥n"  but if I look in my
> local copy of the source tree I see  "\n".

Odd, indeed. I see correct '\n' in the mail I sent, but in your mail
here it's coming out wrong -- lkml.org shows badness as well. Hmmm,
"insert file" using ^R in alpine never gave any problems before ...
--464262402-428625364-1188765171=:29617--
