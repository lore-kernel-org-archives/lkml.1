Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbZAOPQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbZAOPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 10:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZAOPQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 10:16:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:16435 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbZAOPQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 10:16:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fzjx6qfNAn6wfkU44J7zuhwvRKskiRzz4do99LPMUBoKcTWlLiMSZF+JLGXcZ9aZq8
         GSvbylBygXUor1talU2yFi0HxnMfno/FcfTqfxpuCwMh4658L5v30qNeaJlFCM1/q04T
         SKT64I0ES/G6/eQ8TdGWGpmy+uXRecG2b9zSs=
MIME-Version: 1.0
In-Reply-To: <20090115145126.GA1702@elte.hu>
References: <Pine.LNX.4.64.0901140954250.27308@anakin>
	 <20090114153825.GB32082@uranus.ravnborg.org>
	 <3f9a31f40901140759s1542e6cclae1808b796c2b1a9@mail.gmail.com>
	 <Pine.LNX.4.64.0901141732450.26663@anakin>
	 <20090114201513.GC1556@uranus.ravnborg.org>
	 <20090115111134.GB22850@elte.hu>
	 <20090115143717.GA11991@uranus.ravnborg.org>
	 <3f9a31f40901150647n7ef5b2dfuf5c588f584c2a472@mail.gmail.com>
	 <20090115145046.GB872@elte.hu> <20090115145126.GA1702@elte.hu>
Date: Thu, 15 Jan 2009 20:46:04 +0530
Message-ID: <3f9a31f40901150716j3fa7a6c1m37c37034a967bf72@mail.gmail.com>
Subject: Re: [PULL -tip] fixed few make headers_check warnings
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Thu, Jan 15, 2009 at 8:21 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> btw., could you please put them into your Git tree and post a pull
> request, so that i can check how many warnings there are left?
>

Patches are still in my git tree and I also cross checked that they
are mergeable with your latest -tip.

The following changes since commit ae2659bcd0b5bf34dd4b03f1db0a2942cc09b8e6:
 Ingo Molnar (1):
       Merge branch 'x86/mm'

are available in the git repository at:

 git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git
master

Jaswinder Singh Rajput (7):
     include of <linux/types.h> is preferred over <asm/types.h>
     found __[us]{8,16,32,64} type without #include <linux/types.h>
     capability.h: extern's make no sense in userspace
     coda_psdev.h: extern's make no sense in userspace
     in6.h: extern's make no sense in userspace
     nubus.h: extern's make no sense in userspace
     socket.h: extern's make no sense in userspace

Thanks

--
JSR
