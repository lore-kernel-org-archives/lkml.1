Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbXH1PXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbXH1PXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 11:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbXH1PXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 11:23:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:15831 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbXH1PXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 11:23:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QD0AvsKKhC0D4Eroa9GFEaNf4APW8SvJnYBDnR3U9RlufWvXg10B7GJvKyMiwdPBF7xrPGRP3ZU0wSKuo0XiVjdiZ9zuJ2ekAfxFbw9RbaIFAKxeIUcsiOvS0y1c2m0BjAXC1dnPS0X4DIaxqkfUxc1v9+3UOc9qkWBLE7cYJtw=
Message-ID: <ab40e9c0708280823h38250ef8ya7b3f2ac96c5811b@mail.gmail.com>
Date: Tue, 28 Aug 2007 17:23:01 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: "Gavin Shan" <gshan@alcatel-lucent.com>
Subject: Re: lowlevel_init.c
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <008001c7e986$a20ae160$02fca8c0@gshan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0708280749o1d2d4872m3b7688e36d717c6c@mail.gmail.com>
	 <003a01c7e983$d95fa4a0$02fca8c0@gshan>
	 <ab40e9c0708280804o548ae69du8136d149232e4ba6@mail.gmail.com>
	 <008001c7e986$a20ae160$02fca8c0@gshan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

u-boot/board/realview_eb/lowlevel_init.S
this is the exact path for the file.

2007/8/28, Gavin Shan <gshan@alcatel-lucent.com>:
> I couldn't find out the file.
>
> oak:/home2/gshan/u-boot/board>
> oak>find . -name lowlevel_init.c
> oak:/home2/gshan/u-boot/board>
>
> ----- Original Message -----
> From: "Xu Yang" <risingsunxy@googlemail.com>
> To: "Gavin Shan" <gshan@alcatel-lucent.com>
> Cc: <linux-kernel@vger.kernel.org>
> Sent: Tuesday, August 28, 2007 11:04 PM
> Subject: Re: lowlevel_init.c
>
>
> > Hi Gavin,
> >
> > yes, the file lowlevel_init. c is under board/xxx,
> >
> > but for the board realview-eb this files doesn't contain anything but
> > a dummy funtion. that is why I am wondering where is the board memory
> > partitioin done .
> > thanks,
> >
> > any new comments?
> >
> > regards,
> >
> > yang
> >
> > 2007/8/28, Gavin Shan <gshan@alcatel-lucent.com>:
> > >
> > > ----- Original Message -----
> > > From: "Xu Yang" <risingsunxy@googlemail.com>
> > > To: <linux-kernel@vger.kernel.org>
> > > Sent: Tuesday, August 28, 2007 10:49 PM
> > > Subject: lowlevel_init.c
> > >
> > >
> > > > Hello everyone,
> > > >
> > > > i am trying to run linux on realview_eb_mpcore.
> > > > I read some articles about how to port linux and uboot to a new board,
> > > > according to the article, when I am porting the uboot, i should modify
> > > > a file called lowlevel_init.c , which is in the fold
> > > > board/realview_eb. this file describes the memory partition of the
> > > > board. but in the realview_eb , this file doesn't do this job.
> > > > anyone can tell me , where is it done?
> > > >
> > > > without doing this, the file system can be booted or not?
> > > >
> > > > any comments are appreciated.
> > > >
> > > > regards,
> > > >
> > > > yang
> > >
> > > I don't know what realview_eb_mpcore is actually. I'm supposing you mentioned the uboot.
> > > The files under board/xxx/ directory is related to board layout. I think what you need to do are:
> > >
> > > 1) Make your serial port to work at frist so that you can see any output for debugging.
> > > 2) Try to print more info to debug your issue.
> > >
> > > Gavin
> >
