Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZI2CHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZI2CHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 22:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZI2CHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 22:07:07 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:55778 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbZI2CHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 22:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=szPi/O577NyDGW9DBil7sDMAfDhsmNdHy9njad68DmUvJO9tKvtAo0wTbfI8NQAlQb
         HsYHmelAPzdSBtBo/v+4KSM5BMPfzSYgN/5VQocxcHldjRuZEeqpFMmj3fifYfRQ+Cd+
         sYgW2WfpzimFBq+EppDoCa76FsImCjeNVXQME=
MIME-Version: 1.0
In-Reply-To: <25a94d2a0909281502u2bb383aemdb44f4af8ffdc9e7@mail.gmail.com>
References: <25a94d2a0909281502u2bb383aemdb44f4af8ffdc9e7@mail.gmail.com>
Date: Tue, 29 Sep 2009 10:07:09 +0800
Message-ID: <2375c9f90909281907m523fe2b8w96567b61d859c224@mail.gmail.com>
Subject: Re: visibility of linux source
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Taro Okumichi <tarookumichi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 6:02 AM, Taro Okumichi <tarookumichi@gmail.com> wrote:
> I have written a gcc-tracer and html-formatter that shows
> Linux's init/main.c formatted as dynamic-html including:
>  o expand macros by clicking on them
>  o expand include directives
>  o traverse c-structs
> Address:
> http://cfw.sourceforge.net/htmltag/init/main.c.pinfo.html
> I have only processed init/main.c (50mb mysql content)
> As far as I understand (maybe I am wrong) this kind of
> visibility is not achieved till now.
> Note:
> I tested firefox (3.5) and konqueror. The first page takes ~
> 10 Seconds to load, therefore be patient until the right
> side init/main.c content is shown (ajax fetch from a mysql db).

{snip}

> Using a ajax request to retrieve the html, the Mysql db
> content is ~ 50 mb for the whole of main.c. No optimization
> is done, so this includes lots of redundant entries.
>
> The left index frame should not be used, the javascript code
> is kind of buggy, so only use the right frame where the code
> is shown.
>
> Also: There is a bug in when closing a "include" directive section:
> (At least in firefox) A new windows will pop up (I didnt find out
> why this is the case). Click the window to the back and continue
> (not closing it otherwise the next #include directive opens it again...

Awesome!

Taro, you are doing a nice work! Thanks!

I just wonder how can I go back if I follow a function definition from one
file to another? Ajax makes going back to previous page impossible.
:-/

Thanks!
