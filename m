Return-Path: <linux-kernel-owner+w=401wt.eu-S937393AbXFGWUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937393AbXFGWUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937052AbXFGWUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:20:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47067 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S936907AbXFGWUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:20:14 -0400
Date: Thu, 7 Jun 2007 23:22:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Jesper Juhl <jesper.juhl@gmail.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <20070607232248.332edee8@the-village.bc.nu>
In-Reply-To: <20070607193413.GR5500@stusta.de>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
	<9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com>
	<Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr>
	<20070607193413.GR5500@stusta.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 21:34:13 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> On Thu, Jun 07, 2007 at 04:28:20PM +0200, Jan Engelhardt wrote:
> > 
> > On Jun 6 2007 11:05, Jesper Juhl wrote:
> > >
> > > - Source files should be 7bit ASCII
> > 
> > Nah. Think of....
> > 
> > MODULE_AUTHOR("J. Ørsted <jorsted@foobar.com>");
> >...
> 
> NO!
> 
> Code must be 7bit ASCII.
> This includes everything that gets into the kernel image.

Disagree Adrian

For quoted strings you want to include Unicode where appropriate, and the
names of people happens to be highly appropriate. Trashing non US names
is just rude, and in many cases extremely problematic because losing
accent marks totally changes the meaning of the word and the
pronunciation of the name.

Now anyone who puts UTF-8 in the driver name or module options should get
a lot of NAKs but putting it in the Author name is precisely where it is
appropriate and correct. I suspect Author names are almost the only case
where this is appropriate and/or neccessary.

Alan
