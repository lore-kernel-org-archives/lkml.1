Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0CDI1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:27:34 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:64119 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab0CDI1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:27:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TnbggHg4MJk6PWRmizSeJHYoNQujt9DLBrEYpZs9Tm8uZd1xF6l3+Uo9xZzHwcSOsO
         smcuv8FLXLs0jZOJQ4soFGpR2/ohtBAqzss69375T6FkjzTcj72I4YUujlVIv0vPwCP1
         8jAJQDPtp3EG7hpSmpqIDOMbhdjB+gUZyKRX4=
MIME-Version: 1.0
In-Reply-To: <1267689791.10101.4.camel@marge.simson.net>
References: <40a4ed591003031245g79cca873t89e90545337a9067@mail.gmail.com>
	 <1267673633.6416.7.camel@marge.simson.net>
	 <40a4ed591003032322l4ad2dc00sd3de718b5a76089b@mail.gmail.com>
	 <1267688823.7029.8.camel@marge.simson.net>
	 <40a4ed591003032355t46e356f8qadfded7450934b51@mail.gmail.com>
	 <1267689791.10101.4.camel@marge.simson.net>
Date: Thu, 4 Mar 2010 09:27:29 +0100
Message-ID: <40a4ed591003040027u560cdf52q2615868bbc4c7a00@mail.gmail.com>
Subject: Re: evdev keyboard driver stopped working after upgrading from Kernel 
	2.6.33-rc8 to 2.6.33 (official release)
From: Zeno Davatz <zdavatz@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
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

So I do:

git bisect start
git bisect good v2.6.33-rc8
make
copy bzImge
lilo
reboot
see if it works

correct?

best
Zeno
