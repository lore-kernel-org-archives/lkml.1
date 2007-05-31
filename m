Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbXEaR0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbXEaR0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 13:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbXEaRZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 13:25:53 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:28925 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbXEaRZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 13:25:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iNvcOhLfeDX+h1lNtGkRes1bRNTFzyV1D0kZtWSodeh8vlhCaXWlywHTcU5k9WuZBa6AvawyyZ1yrAcC/5Mp7UceQSkT8oYwhC48upwnsTyGtcja6qWuAeU9paHX3RpUvV82glu32WXS/fdJjvNAX1GZZQFwh+j0JV2ny/dR8hs=
Message-ID: <6278d2220705311025q6ee030e2kd44b7302a50ac902@mail.gmail.com>
Date: Thu, 31 May 2007 18:25:49 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: Compact Flash performance...
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>
In-Reply-To: <465EBE20.6090803@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>
	 <465E3FF0.9010709@rtr.ca>
	 <6278d2220705310222rde9ad28ndfd8feced84a3c6f@mail.gmail.com>
	 <465EBE20.6090803@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/07, Mark Lord <lkml@rtr.ca> wrote:
> Daniel J Blueman wrote:
> > Hi Mark,
> >
> > Thanks for the reply; here is the raw identification data:
> >
> > # hdparm --Istdout /dev/sdb
> >
> > /dev/sdb:
[snip]
> Ooops.. wrong drive.  That's NOT a CF card.   Try again?

Whoops, yes. Here is the expected data:

# hdparm --Istdout /dev/sdb

/dev/sdb:
848a 1f1c 0000 0010 0000 0240 003f 007a
7e40 0000 2020 2020 3131 3638 3032 4432
3830 374a 3333 3335 0002 0002 0004 4844
5820 342e 3034 5361 6e44 6973 6b20 5344
4346 582d 3430 3936 2020 2020 2020 2020
2020 2020 2020 2020 2020 2020 2020 0004
0000 0300 0000 0200 0000 0007 1f1c 0010
003f 7e40 007a 0100 7e40 007a 0000 0007
0003 0078 0078 0078 0078 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0010 0000 0020 4004 4000 0000 0004 4000
101f 0000 0000 0000 0000 2000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0082 001b 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
-- 
Daniel J Blueman
