Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab0CDJ2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:28:19 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:36001 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0CDJ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:28:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=PeM8Zgai7pdx+65dMardrsuudDhNiaps4U95hIofGbt52pKZBVTtr9BgAtGNxqYdN8
         kobPERKoGw1MkvYjiaN0w9iCIYeAo5NQgPQ+BkUN01THvSM4xbzku/cAodZ9W9FmjZkR
         Jtq+zUfn9AETFMpw7NoRrUIYwNH4kYUzhE3v8=
MIME-Version: 1.0
In-Reply-To: <40a4ed591003040126t751b9ee5o94c2cd3ce2d5f58b@mail.gmail.com>
References: <40a4ed591003031245g79cca873t89e90545337a9067@mail.gmail.com>
	 <1267673633.6416.7.camel@marge.simson.net>
	 <40a4ed591003032322l4ad2dc00sd3de718b5a76089b@mail.gmail.com>
	 <1267688823.7029.8.camel@marge.simson.net>
	 <40a4ed591003032355t46e356f8qadfded7450934b51@mail.gmail.com>
	 <1267689791.10101.4.camel@marge.simson.net>
	 <40a4ed591003040126t751b9ee5o94c2cd3ce2d5f58b@mail.gmail.com>
Date: Thu, 4 Mar 2010 10:28:13 +0100
Message-ID: <40a4ed591003040128o618c1bd8h98a5d4dc50c9e413@mail.gmail.com>
Subject: evdev keyboard driver stopped working after upgrading from Kernel 
	2.6.33-rc8 to 2.6.33 (official release)
From: Zeno Davatz <zdavatz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 9:03 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Thu, 2010-03-04 at 08:55 +0100, Zeno Davatz wrote:
>
>> Ok, I will try that. Can you give a short input of how I should start bisecting?
>
> git bisect start
> git bisect good v2.6.33-rc8
> git bisect bad v2.6.33
>
> build and test each iteration, should be quick/painless if it's rc8.

Ok, confirmed: http://lkml.org/lkml/2010/3/4/33

With -rc8 my keyboard is backup and working!

So it must be a change between rc8 and final 2.6.33

Thank you for your greenhorn git bisect tutorial.

I am curious where the bug is!

Best
Zeno
