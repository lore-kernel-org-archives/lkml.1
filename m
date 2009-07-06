Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbZGFFue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbZGFFue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 01:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZGFFu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 01:50:26 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:25677 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZGFFuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 01:50:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=u27z1/Ak8rRXe/vsc1deNVCk4cCuirhVyBvOA7bBX2vYRGtMDI1mWHU8Fd149Eqgtc
         duy7v3zl3st570QKs9j/BlV99xR95dbXT6pSi/aOufW+Rt34z4HK5dhcqwcJzYKoPiNN
         BNdwTRt5Qp0o/KEHfiKDvX3iwzHleYQim0Cz8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0907051735030.3210@localhost.localdomain>
References: <E1MLa4R-00054S-94@pomaz-ex.szeredi.hu> <2547.1246393535@redhat.com> 
	<E1MLruc-0007O1-Sp@pomaz-ex.szeredi.hu> <a36005b50907051235h17f559c6w1937998c7eec0b0@mail.gmail.com> 
	<alpine.LFD.2.01.0907051735030.3210@localhost.localdomain>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sun, 5 Jul 2009 22:50:08 -0700
Message-ID: <a36005b50907052250n7a73a19r3ce674f08a402703@mail.gmail.com>
Subject: Re: [RFC PATCH] vfs: new open(2) flag to open filesystem node
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, dhowells@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 5, 2009 at 17:40, Linus
Torvalds<torvalds@linux-foundation.org> wrote:
> O_SEARCH is only meaningful for directories. For anything else, it's not
> at all POSIX - it's expressly defined to be "undefined".

And this is why there is the differentiation with O_EXEC.  Yes, i
didn't mention it in the last email.  But I mentioned it when it came
up the first time.

I don't say this is indeed what is wanted/needed here.  But there are
IMO some similarities and I think implementing O_SEARCH and O_EXEC is
desirable.  If it means completely different implementations from te
proposed O_NODE, so be it.  But my gut tells me there is some overlay.
