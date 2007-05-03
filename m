Return-Path: <linux-kernel-owner+w=401wt.eu-S1031307AbXECOOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031307AbXECOOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031321AbXECOOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:14:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:62642 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031307AbXECOOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:14:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oT0QlqXgj8tDBOrHqTDxT8R7dykG2cXyAWJn5vNcvYGC6AMR7b8kbulLkU1kOTdqi2zRmQ4o8r3HPmwqVvcp3glNBe0B77T3zhREfB5J/izyi8kqvJxP7ziKN+CistelUoDT+O0w4++FCwrKOILFn5xtTFFI7VYoS6P2v6ZCwdQ=
Message-ID: <787b0d920705030714k3b290d2csa38a5df63c692d6f@mail.gmail.com>
Date: Thu, 3 May 2007 10:14:30 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: console font limits
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Antonino A. Daplas" <adaplas@gmail.com>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
In-Reply-To: <Pine.LNX.4.61.0705030902430.18504@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>
	 <Pine.LNX.4.64.0705011347300.27246@anakin>
	 <1178021516.4372.62.camel@daplas> <46375738.1010007@zytor.com>
	 <787b0d920705010849u52a4d6c3o2f1f800521ad5b95@mail.gmail.com>
	 <Pine.LNX.4.61.0705021953030.18504@yvahk01.tjqt.qr>
	 <787b0d920705022317j485cbe26wc83f071834c53584@mail.gmail.com>
	 <Pine.LNX.4.61.0705030902430.18504@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> On May 3 2007 02:17, Albert Cahalan wrote:

> > Those sizes are unreadable on the 200 dpi OLPC XO screen,
>
> Hm that should have read, for you:
> I don't object implementing support for larger sizes.
> (But I wonder how that should work without FB/CVIDIX/SVGA/VESA extensions.)
>
> Note that I was assuming that no FB is used:

I'm assuming that the FB is used. Neither of my two
computers can do VGA text mode. Even for computers
which can do VGA text mode, if you want large fonts
(either by number of characters or by character width)
you need to use FB. That's just a requirement; anything
else would be insane.

> For everything beyond Latin, fbiterm should work a lot better.

Then, as with X, you have problems with kernel messages.
Reliably sending printk through a userspace console is not
even possible. (consider a panic, OOM, or runaway RT task)
