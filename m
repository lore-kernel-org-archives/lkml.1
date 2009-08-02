Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbZHBUjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbZHBUjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbZHBUja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:39:30 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52431 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbZHBUj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DGU1fI8PEyZm9+qqm9ohIgq0zpLvI2so2xA6K00PSP8qya0zn0+KFxbm7TQJLhj6XU
         URE+uFquU+ynd2AeCqBL06kdIP7dHn4PeOX3urmLrFE9EBKcXHzZ92+jmW0jveiDGXXk
         XbDcQPyI7iGlJ3jcSEj5inlaQpYoskGm39ctE=
MIME-Version: 1.0
In-Reply-To: <81b0412b0908021125x654fd337hf03a67385302d6e4@mail.gmail.com>
References: <81b0412b0908020940l3fcb2c2ds184fa87df82b5730@mail.gmail.com>
	 <200908021919.11169.oliver@neukum.org>
	 <81b0412b0908021125x654fd337hf03a67385302d6e4@mail.gmail.com>
Date: Sun, 2 Aug 2009 22:39:28 +0200
Message-ID: <81b0412b0908021339s739c07edvd4d5eb4c21cfa167@mail.gmail.com>
Subject: Re: Oops in CDC ACM after an Openmoko phone (neo1973) changes its usb 
	interface from ACM to Ethernet
From: Alex Riesen <raa.lkml@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.name>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 2, 2009 at 20:25, Alex Riesen<raa.lkml@gmail.com> wrote:
> I shall try to find the -rc2 which oopses (I suspect it is the one
> just before -rc3).
>

And this is after I put "for(;;);" at the end of dump_stack in v2.6.31-rc3:
http://home.arcor.de/fork0/bug/neocrash.jpg (~110k)

And this one is with v2.6.31-rc5 (it has usb_disconnect in it):
http://home.arcor.de/fork0/bug/neocrash-rc5.jpg (~86k)
(config: http://home.arcor.de/fork0/bug/neocrash-config-rc5.txt)

I couldn't find the -rc2 which didn't lock up. They all do now. I don't know
anymore how I made that -rc2 where I got the previous oops from.

Any idea how to disable stack dumps so that there is more place
for other output on a laptop screen? (no chance for serial console)
Or maybe a high-speed video camera can stand a chance?
