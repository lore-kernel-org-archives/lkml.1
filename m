Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbXHQEhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbXHQEhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 00:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXHQEhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 00:37:36 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:29925 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbXHQEhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 00:37:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BpAj/i6fC8bgeTfr53jFanVUZiPtNKEyod29PEIjOUQQQbOWhlfRIRxcLLv0k1bbDRr2w5Z6Q1ZDL73EUg2wjwTD50U1BFUW5FFhwiRu6FVZKpGAUFeI8w8OtTdWtH8BIV2O9CjOJSpupPORWoNdWtUSPLKilPua8i5GTIojM5U=
Message-ID: <653402b90708162137r6079d431ud91216bb7b140610@mail.gmail.com>
Date: Fri, 17 Aug 2007 06:37:33 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH] [120/2many] MAINTAINERS - CFAG12864BFB LCD FRAMEBUFFER DRIVER
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <1187272507.5906.80.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bff946.crSIrCRHeVaUjuwb%joe@perches.com>
	 <653402b90708160216k1ea20490k7a846bd019e44b3d@mail.gmail.com>
	 <1187272507.5906.80.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/07, Joe Perches <joe@perches.com> wrote:
> On Thu, 2007-08-16 at 11:16 +0200, Miguel Ojeda wrote:
> > I think you could add also:
> >  +F:     Documentation/auxdisplay/cfag12864bfb
>
> This is what I have now:
>
> CFAG12864BFB LCD FRAMEBUFFER DRIVER
> P:      Miguel Ojeda Sandonis
> M:      maxextreme@gmail.com
> L:      linux-kernel@vger.kernel.org
> W:      http://auxdisplay.googlepages.com/
> S:      Maintained
> F:      Documentation/auxdisplay/cfag12864bfb
> F:      drivers/auxdisplay/cfag12864bfb.c
> F:      include/linux/cfag12864b.h
>
> Joe
>
>

Oh, I got confused by the different emails:

   Documentation/auxdisplay/cfag12864bfb

does not exist. I meant

   Documentation/auxdisplay/cfag12864b

Also, in this patch:

    [PATCH] [119/2many] MAINTAINERS - CFAG12864B LCD DRIVER

You could add the same line:

   Documentation/auxdisplay/cfag12864b

As it is related to the same stuff: cfag12864b is the driver that
makes the LCD work along with ks0108; and cfag12864bfb is a
framebuffer to work with the LCD from userspace. I named it
"cfag12864b" because that is the name of the LCD, so people will not
get confused with the "fb".

As Documentation/auxdisplay/cfag12864b describes both at the same
time, it is OK to add them in both entries.

Sorry for the mistake.

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
