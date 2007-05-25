Return-Path: <linux-kernel-owner+w=401wt.eu-S1764340AbXEYRdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764340AbXEYRdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759354AbXEYRdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:33:37 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:30801 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbXEYRdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:33:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bSB52LF0T8AOkEC4UtJE4qivb8Ysftxb3dW4i8CA4gdTDdEaGmr4FBmlVpbxT3sEXGm/HnzFOBji6hMvG+7YOZV4B+MpbudZqzZKXNqBLNeX18xaX1Up0invaMPd4oM7zjyAvXPw17JzK1UIJr8rhpLgH+SL+V/gSNUn+AMv+yk=
Message-ID: <4cefeab80705251033g6c8bdfb0l1499befb355b9c0f@mail.gmail.com>
Date: Fri, 25 May 2007 23:03:33 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Bret Towe" <magnade@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>,
       linux-mm-cc@laptop.org, "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <dda83e780705251002hed0e861x26a0b0ea6260dd52@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/07, Bret Towe <magnade@gmail.com> wrote:
> On 5/24/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> > On 5/25/07, Bret Towe <magnade@gmail.com> wrote:
> > > On 5/24/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> > > > On 5/23/07, Bret Towe <magnade@gmail.com> wrote:
> > > > > On 5/23/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
>
> [  237.556167] LZO compress successful: orig_size=17448, comp_size=8183
> [  253.320760] LZO decompress successful: decomp_size=17448
>
> 2221c586e3eb869af7f4333d4f56b441b9aa8414  test-input
> 2e6c96b687274b629308b29835cebd3af989e0c7  output
>
> ppc however seems bust
> the computer is a g4 mini


Since lzo1x_decompress() itself is saying that decompression was
successful, it is really strange to have different sha-sums. It seems
that it's the fault with compress-test module itself. I will look more
closely into this and reply back.

Thanks,
Nitin
