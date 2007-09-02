Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbXIBVS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbXIBVS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 17:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbXIBVST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 17:18:19 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:46509 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbXIBVSS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 17:18:18 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH -mm] sisusbvga: Fix bug and build warnings
Date: Sun, 2 Sep 2007 22:18:06 +0100
User-Agent: KMail/1.9.7
Cc: "Satyam Sharma" <satyam@infradead.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Thomas Winischhofer" <thomas@winischhofer.net>,
       "Greg Kroah-Hartman" <greg@kroah.com>,
       linux-usb-devel@lists.sourceforge.net
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0709030159320.29617@enigma.security.iitk.ac.in> <9a8748490709021323k3d4adbddv53346aacdd66ab57@mail.gmail.com>
In-Reply-To: <9a8748490709021323k3d4adbddv53346aacdd66ab57@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709022218.06849.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 September 2007 21:23:16 Jesper Juhl wrote:
> On 02/09/07, Satyam Sharma <satyam@infradead.org> wrote:
> > Hi Jesper,
> >
> > On Sun, 2 Sep 2007, Jesper Juhl wrote:
> > > > -       if (!(interface = usb_find_interface(&sisusb_driver,
> > > > subminor))) { -               dev_err(&sisusb->sisusb_dev->dev,
> > > > "Failed to find interface¥n");
> > >
> > > Odd how in your patch the line ends with  "¥n"  but if I look in my
> > > local copy of the source tree I see  "\n".
> >
> > Odd, indeed. I see correct '\n' in the mail I sent, but in your mail
> > here it's coming out wrong -- lkml.org shows badness as well. Hmmm,
> > "insert file" using ^R in alpine never gave any problems before ...

The encoding is set to ISO-2022-JP, this is probably breaking things.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

