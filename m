Return-Path: <linux-kernel-owner+w=401wt.eu-S967072AbXFGXON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967072AbXFGXON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965902AbXFGXN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:13:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:16074 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966418AbXFGXNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M69jog128PZR42XGsVofijpPgXH+qsBfv7bUePmSKDZRJwuyoZRYhq01Of1aXhiiCYWPkEYOoQQ0NtFXVEU/rsVQaNIHazb75T5m/VFBSGqrU8wQmKBrOY0SsI0IVcNmiWI7NeaxbpIUy/Z5tol3MPeIMOX27zz1uhAQhyLbBVE=
Message-ID: <a44ae5cd0706071613g6a3fb677y5880ab2f86ef590@mail.gmail.com>
Date: Thu, 7 Jun 2007 16:13:53 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc4-mm2 -- Bus #03 (-#06) is hidden behind transparent bridge #02 (-#02) (try 'pci=assign-busses')
Cc: LKML <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>
In-Reply-To: <20070607132709.32cd9f4a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0706071133w19272d8bkb392ffe58f1af6b7@mail.gmail.com>
	 <20070607132709.32cd9f4a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 7 Jun 2007 11:33:12 -0700
> "Miles Lane" <miles.lane@gmail.com> wrote:
>
> > Andrew, is it okay to debug this with the MM tree?  I see this with
> > Linus' kernels as well.  It's a long-standing issue, but I have always
> > just used pci=assign-busses in the past.
> >
>
> Dunno, but let's not miss an opportunity to bug the PCI maintainer.
>
> >
> > [    0.215128] PCI: Transparent bridge - 0000:00:1e.0
> > [    0.215142] PCI: Scanning behind PCI bridge 0000:02:09.0, config
> > 000000, pass 0
> > [    0.215158] PCI: Scanning behind PCI bridge 0000:02:09.0, config
> > 000000, pass 1
> > [    0.215184] PCI: Bus #03 (-#06) is hidden behind transparent bridge
> > #02 (-#02) (try 'pci=assign-busses')
> > [    0.215187] Please report the result to linux-kernel to fix this permanently
> > [    0.215192] PCI: Bus scan for 0000:02 returning with max=06
> > [    0.215199] PCI: Scanning behind PCI bridge 0000:00:1e.0, config
> > 020200, pass 1
> > [    0.215209] PCI: Bus scan for 0000:00 returning with max=06
> >
>
> Does the kernel otherwise work OK with and without pci=assign-busses?

(Crud!  GMail likes to send stuff "Reply to Sender" with its default
UI.  Whoops.)

As far as I can tell.  I play with this build some more without adding
that kernel boot parameter.

       Miles
