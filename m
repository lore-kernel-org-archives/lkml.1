Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbZGFMaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbZGFMaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 08:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZGFMaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 08:30:03 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50684 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZGFMaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:30:02 -0400
To: drepper@gmail.com
CC: torvalds@linux-foundation.org, miklos@szeredi.hu, dhowells@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
In-reply-to: <a36005b50907052250n7a73a19r3ce674f08a402703@mail.gmail.com>
	(message from Ulrich Drepper on Sun, 5 Jul 2009 22:50:08 -0700)
Subject: Re: [RFC PATCH] vfs: new open(2) flag to open filesystem node
References: <E1MLa4R-00054S-94@pomaz-ex.szeredi.hu> <2547.1246393535@redhat.com> 
	<E1MLruc-0007O1-Sp@pomaz-ex.szeredi.hu> <a36005b50907051235h17f559c6w1937998c7eec0b0@mail.gmail.com> 
	<alpine.LFD.2.01.0907051735030.3210@localhost.localdomain> <a36005b50907052250n7a73a19r3ce674f08a402703@mail.gmail.com>
Message-Id: <E1MNnKV-0001fu-Tn@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Jul 2009 14:29:55 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jul 2009, Ulrich Drepper wrote:
> On Sun, Jul 5, 2009 at 17:40, Linus
> Torvalds<torvalds@linux-foundation.org> wrote:
> > O_SEARCH is only meaningful for directories. For anything else, it's not
> > at all POSIX - it's expressly defined to be "undefined".
> 
> And this is why there is the differentiation with O_EXEC.  Yes, i
> didn't mention it in the last email.  But I mentioned it when it came
> up the first time.
> 
> I don't say this is indeed what is wanted/needed here.  But there are
> IMO some similarities and I think implementing O_SEARCH and O_EXEC is
> desirable.

O_SEARCH loosens the security model somewhat: a process could keep
search access to a directory even after the permissions have been
changed.

O_EXEC is similar, but "execute" is really not an access, just a flag,
so...

Thanks,
Miklos
