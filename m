Return-Path: <linux-kernel-owner+w=401wt.eu-S1763389AbXJTJhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763389AbXJTJhn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 05:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbXJTJhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 05:37:34 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:60839 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbXJTJhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 05:37:33 -0400
From: Nick Warne <nick@ukfsn.org>
Reply-To: nick@ukfsn.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: New CD/DVD drive - 80-wire cable detection failure
Date: Sat, 20 Oct 2007 10:37:31 +0100
User-Agent: KMail/1.9.7
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200710181832.42906.nick@ukfsn.org> <200710192304.23749.nick@ukfsn.org> <200710200028.21860.bzolnier@gmail.com>
In-Reply-To: <200710200028.21860.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710201037.31283.nick@ukfsn.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2007 23:28:21 Bartlomiej Zolnierkiewicz wrote:
> On Saturday 20 October 2007, Nick Warne wrote:
> > On Friday 19 October 2007 22:44:27 Bartlomiej Zolnierkiewicz wrote:
> >
> > hdparm -I
>
> It should have been hdparm --Istdout (sorry, once again).
>

hdparm --Istdout /dev/hdd

/dev/hdd:
85c0 0000 0000 0000 0000 0000 0000 0000
0000 0000 2020 2020 2020 2020 2020 2020
2020 2020 2020 2020 0000 0000 0000 5342
3030 2020 2020 5453 5354 636f 7270 2043
4444 5644 5720 5348 2d53 3230 324a 2020
2020 2020 2020 2020 2020 2020 2020 0000
0000 0b00 0000 0200 0200 0006 0000 0000
0000 0000 0000 0000 0000 0000 0000 0007
0003 0078 0078 017f 0078 0000 0000 0000
0000 00f8 0210 0000 0000 0000 0000 0000
00f8 0210 0210 0000 0000 0000 0000 0000
041f 0000 8005 3200 005b 2000 0000 0000
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
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 a8a5


There is some confusion on this drive now.  Somebody sent me a link to tech 
specs and that states it only does udma2 mode - but the specs I found state 
it does udma4?

http://downloadcenter.samsung.com/content/UM/200708/20070823084759796_SH-S202J_ENG.pdf

So knowing what these hardware firms are like, maybe it _is_ only udma2?

Thanks,

Nick
-- 
Free Software Foundation Associate Member 5508
