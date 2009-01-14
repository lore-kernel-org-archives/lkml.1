Return-Path: <linux-kernel-owner+w=401wt.eu-S1763906AbZANQAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763906AbZANQAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763715AbZANP7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:59:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:7701 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711AbZANP7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:59:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YJU5irDxSdyC/HZv6GG5tUIkJ2Dajr0unNc3zv70vIYia8J0hB3vcutZZKmWUeS9Xb
         QoFDwIDrkX+iPpzGtfADi7CyvAvy+ceb/Xq3BB9gJCzFlMHjJF7wwDjgM5IDA+iNr4ZZ
         Wth5jsoqJyxcYSfD8PlTBfSk6vRwD0th57xNI=
MIME-Version: 1.0
In-Reply-To: <20090114153825.GB32082@uranus.ravnborg.org>
References: <1231836016.3212.41.camel@jaswinder.satnam>
	 <Pine.LNX.4.64.0901140954250.27308@anakin>
	 <3f9a31f40901140129i1389f47frf32808f3a695a118@mail.gmail.com>
	 <20090114153825.GB32082@uranus.ravnborg.org>
Date: Wed, 14 Jan 2009 21:29:35 +0530
Message-ID: <3f9a31f40901140759s1542e6cclae1808b796c2b1a9@mail.gmail.com>
Subject: Re: [PULL -tip] fixed few make headers_check warnings
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

On Wed, Jan 14, 2009 at 9:08 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> >

>
> I appreciate your work but I will like to question the approach.

My approach was:
"PATCH should solve a problem per file", like:
 capability.h: extern's make no sense in userspace
 coda_psdev.h: extern's make no sense in userspace
 in6.h: extern's make no sense in userspace
 nubus.h: extern's make no sense in userspace
 socket.h: extern's make no sense in userspace

But this warnings was in many files:
 include of <linux/types.h> is preferred over <asm/types.h> : 15 files
 found __[us]{8,16,32,64} type without #include <linux/types.h> : 52 files

So in place of making 15 + 52 = 67 patches, I made 2 patches for each warning.

> We should rather take the warnings as an indication that this
> file needs to be looked over and fix not only the warnings
> reported but rater to fix all the questionable issues on a file-by-file basis.

Should I make 67 patches ?

--
JSR
