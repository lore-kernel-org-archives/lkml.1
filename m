Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZCFJv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZCFJv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbZCFJvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:51:17 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:42906 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZCFJvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:51:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wbKAlWzYYhraqAhMofRzEzkHGguJXcpTlJGsxFdRl5x/5ZPPrvW00b9YXCke6ws4wy
         7fz4/pwrKovzBMRzXSIhc4jetMaD5LnHYfFekHIxrmpVJTFvOQ86HYola+RzsMqlLwtk
         bm5tyf3SaXZptypmuuIuUeZmsT7QltEyCJiLY=
MIME-Version: 1.0
In-Reply-To: <10f740e80903060150p565e9703u81d4fe47cb599ab@mail.gmail.com>
References: <200903060042.19084.rob@landley.net>
	 <20090306084848.GO22605@hack.private>
	 <10f740e80903060150p565e9703u81d4fe47cb599ab@mail.gmail.com>
Date: Fri, 6 Mar 2009 10:51:12 +0100
X-Google-Sender-Auth: 83610bb328ff0aac
Message-ID: <10f740e80903060151w779bbd11ld2fcc437ac7ac321@mail.gmail.com>
Subject: Re: [PATCH] Fix ARCH=um segfault on x86-64.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Rob Landley <rob@landley.net>, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 6, 2009 at 10:50, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Fri, Mar 6, 2009 at 09:48, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Fri, Mar 06, 2009 at 12:42:14AM -0600, Rob Landley wrote:
>>>Apparently, nobody other than me has ever attempted to use User Mode Linux
>>>built from 2.6.28 on x86-64, because it doesn't work.  It still doesn't work
>>>in current git.  I complained about it not working back in January:
>>>
>>>http://sourceforge.net/mailarchive/forum.php?thread_name=200901130159.04389.rob%40landley.net&forum_name=user-
>>>mode-linux-devel
>>>http://lkml.indiana.edu/hypermail/linux/kernel/0901.2/00669.html
>>>
>>>And today, I bothered to track down why.
>>>
>>>This is the commit that broke it, when Peter Anvin merged x86 and x86-64 for
>>>ARCH=um: http://kernel.org/hg/linux-2.6/rev/117978
>>>
>>>Here's a patch that fixes it for me:
>>
>> Thanks, Bob!
>
> I've just did a build of plain v2.6.28 on amd64 aka x86-64. The
> resulting image ran fine.

So I'm wondering: why does it work for me and not for you?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
