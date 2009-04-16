Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbZDPHYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbZDPHYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZDPHXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:23:54 -0400
Received: from mail-bw0-f161.google.com ([209.85.218.161]:46883 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbZDPHXx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:23:53 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Apr 2009 03:23:52 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o9OnJ3/BxBqjlYAPQtGpkASGtoIu5i3lXgY+rQLDbR9CtvdGR9MlgKkxOnQ4IO7G2R
         1p9Bob1jWXuLQoUhGFDJtDIjeGzyCcQ2MZIxfm/W430X5XjrM/y6pv0eeWSSmoQ19/q5
         ZS+EafVyBI5WNlu2uhFBCyhc5CksdFdWkoAMY=
MIME-Version: 1.0
In-Reply-To: <20090416054205.GX26366@ZenIV.linux.org.uk>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFA@mi8nycmail19.Mi8.com>
	 <19f34abd0904152146l3db9961bt3b52f224abc8d960@mail.gmail.com>
	 <20090416054205.GX26366@ZenIV.linux.org.uk>
Date: Thu, 16 Apr 2009 09:17:27 +0200
Message-ID: <19f34abd0904160017wa910dd5v56174f7966c35a4f@mail.gmail.com>
Subject: Re: [PATCH] block/genhd.c: fix sparse warning
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/16 Al Viro <viro@zeniv.linux.org.uk>:
> On Thu, Apr 16, 2009 at 06:46:32AM +0200, Vegard Nossum wrote:
>> 2009/4/16 H Hartley Sweeten <hartleys@visionengravers.com>:
>> > Fix sparse warning in block/genhd.c.
>> >
>> > ?? ?? ?? ??warning: symbol '__mptr' shadows an earlier one
>> >
>> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>>
>> Hi,
>>
>> Just a heads up: There seems to be some sort of consensus that this
>> type of patch title is not a very good one. (What about "remove
>> variable shadowing"?)
>
> Indeed.  Speaking of other kind of unpleasantness, could you please
> configure your mail-luser-agent to *NOT* replace tabs with series
> of spaces/nbsp?  That crap is very annoying - these strings of
> U+00A0 U+00A0 U+00A0 et sodding cetera are gratuitously making life
> painful for non-UTF8 terminals.

Oh, was that my fault?

That's strange, is this something new in Gmail? Can't remember seeing
this before. It seems that something changed; compare:

Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

before to

Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

...hm...

I'll try to fix it, thanks.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
