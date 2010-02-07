Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0BGNw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 08:52:26 -0500
Received: from mail-fx0-f211.google.com ([209.85.220.211]:34342 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab0BGNwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 08:52:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mKFAhor1ihsYssP9UYRbYdAqYKBaUxwX/3TZRS+JukMbQF6JZvb/A6Kbe+Dh9lM6/h
         iXdqcnKkfFOQ6V+jXpUvY3TECNVbHFmMyMYt0e5OsXGF/8UQrciKhbzVCCkVGtz2Y374
         +iaV9+z1gjQxClshEi4MB8A2DvQ2zpWzx4jL0=
MIME-Version: 1.0
In-Reply-To: <4B6E6959.60708@softplc.com>
References: <4B6E0F88.2020402@softplc.com> <4B6E6959.60708@softplc.com>
Date: Sun, 7 Feb 2010 13:52:23 +0000
Message-ID: <cce9e37e1002070552h6514ecf5u634b184e4928a009@mail.gmail.com>
Subject: Re: SquashFS on ARM9
From: Phillip Lougher <phil.lougher@gmail.com>
To: Dick Hollenbeck <dick@softplc.com>
Cc: linux-kernel@vger.kernel.org,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 7, 2010 at 7:18 AM, Dick Hollenbeck <dick@softplc.com> wrote:
> Dick Hollenbeck wrote:

> The image works OK if I build it with the 32 version of mksquashs on x86 vs x86_64 .
>
> Amazing, there are differences in file format other than endian-ness?

If you've found a difference in filesystems built by mksquashfs on x86
vs x86_64, then it is a *bug*.

>
> So we have at least 3 forms of the file system image now?  I am
> disappointed.  One would have sufficed.  I don't even buy the need for
> LSbyte vs MSbyte being needed.  There should have been only one form of the
> FS image.
>
> Ouch, this seems amateurish.   Can I assume it is the bitfields?   Get rid
> of the bitfields!
>

No need for insults, especially as it is based on an outdated
understanding.  Squashfs became fixed endian, and lost the bit-fields
in Squashfs 4.0.

> For now I don't need anymore help.  Sorry if I burned down my bridge, I only
> intend to offer strategy to improve the filesystem.
>

I like constructive feedback, excessively critical feedback is usually
self-defeating as it generally gets ignored.  By saying "Sorry if I
burned down my bridge" means you obviously understand this, and so it
is weird you bothered to send the email.

If you'd like the bug tracked down please raise it on the
squashfs.sourceforge.net bug tracker.  Include as much information as
you can including distribution, architecture, Mksquashfs options etc.
It would be best if you can provide a testcase set of source
directories that generate differing Squashfs filesystems on
x86/x86_64.

Phillip
