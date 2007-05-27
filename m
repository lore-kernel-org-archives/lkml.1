Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbXE0DkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbXE0DkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 23:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbXE0DkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 23:40:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:5200 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbXE0Dj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 23:39:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qzAGOh1CCkofS5bNv4Aiu7hbMwLv2Qp729Q/WecHbHQB7dVk9C7ZktzE9OhJWJawToXZbiJlUQfBXTPyQB4+HsZuU7kiGkOPPXmsx3tKRYhEjUNEnImjeXQVWvdHTXukVUEuzFaIxhZKXBf7mGlAAZqcK+AInMUtDjvcnyKiFkw=
Message-ID: <dda83e780705262039r647a329fob59a3d280f5e07ee@mail.gmail.com>
Date: Sat, 26 May 2007 20:39:55 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>,
       linux-mm-cc@laptop.org, "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <4cefeab80705260430y7fbfb6e1wdcab1222611d1509@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <dda83e780705230750j43c9e89eh766fdaafb1d671f3@mail.gmail.com>
	 <4cefeab80705240648k2f3c22ddw13374c9d6b2f521a@mail.gmail.com>
	 <dda83e780705241938h2dadeeb9p61c9294ddfd96990@mail.gmail.com>
	 <4cefeab80705242210k1169d85k97ce803de02dbc2a@mail.gmail.com>
	 <dda83e780705251002hed0e861x26a0b0ea6260dd52@mail.gmail.com>
	 <4cefeab80705260430y7fbfb6e1wdcab1222611d1509@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> Hi Bret,
>
> On 5/25/07, Bret Towe <magnade@gmail.com> wrote:
> >
> > [  237.556167] LZO compress successful: orig_size=17448, comp_size=8183
> > [  253.320760] LZO decompress successful: decomp_size=17448
> >
> > 2221c586e3eb869af7f4333d4f56b441b9aa8414  test-input
> > 2e6c96b687274b629308b29835cebd3af989e0c7  output
> >
> > ppc however seems bust
> > the computer is a g4 mini
> >
>
> Can you please test the 'take 4' version on ppc?
> Just one line change: Please replace call to lzo1x_decompress_safe()
> to lzo1x_decompress() in compress-test module.
>
> Thanks,
> Nitin

results from take 4

dmesg:
[ 1944.508280] LZO compress successful: orig_size=17448, comp_size=8183
[ 1952.098677] LZO decompress successful: decomp_size=17448


root@mini:~# sha1sum /home/bret/test-input output
2221c586e3eb869af7f4333d4f56b441b9aa8414  test-input
2221c586e3eb869af7f4333d4f56b441b9aa8414  output

If you need more testing let me know
