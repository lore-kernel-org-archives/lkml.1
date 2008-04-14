Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbYDNFfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbYDNFfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 01:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbYDNFfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 01:35:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:32705 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYDNFfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 01:35:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fYkVdCSqW9znyGfaMWgQD4Ls9PHlqbmMADibrZRaYX+Sb/2JjKtbzS2w3uE2JyfX2ogfScfp/+nQwgb/y3d+Wsg6J2TLtqFRtmq/amrjmmr5OdzT5NjDkQw6aT5Dh6mIbfTvDNoi/9WLevqBxts0ERJx5oqlyTVSRo5XfqCrXWc=
Message-ID: <517f3f820804132234l48f759ddn18447531e5361754@mail.gmail.com>
Date: Mon, 14 Apr 2008 07:34:56 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch] F_GETPATH for linux
Cc: "Arnd Bergmann" <arnd@arndb.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Al Viro" <viro@ftp.linux.org.uk>
In-Reply-To: <Pine.LNX.4.64.0804131839010.12741@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0804131455030.12741@alien.or.mcafeemobile.com>
	 <200804140300.05719.arnd@arndb.de>
	 <Pine.LNX.4.64.0804131839010.12741@alien.or.mcafeemobile.com>
X-Google-Sender-Auth: b6ed2f4c8e847023
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/14/08, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Mon, 14 Apr 2008, Arnd Bergmann wrote:
>
>  > On Monday 14 April 2008, Davide Libenzi wrote:
>  > > I was working on some bsd/linux compatibility code, and I noticed that we
>  > > do not have F_GETPATH. I know we can readlink /proc/PID/fd/FD (that is
>  > > what I'm doing now, under #ifdef), but I gave a patch a shot anyway.
>  > > Here it is, building but untested ...
>  >
>  > I reviewed the code path for compat_sys_fcntl{,64} for this patch, looks
>  > good in that respect.
>  >
>  > > +error:
>  > > +   free_page((unsigned long) buf);
>  > > +   return size;
>  > > +}
>  > > +EXPORT_SYMBOL(fcntl_getpath);
>  > > +
>  >
>  > Procfs cannot be a module, and there are no other users of this function,
>  > so why do you export it?
>
>
> Springtime export fever? :)
>  I dropped the export. I'll repost as soon as I've five minutes to reboot
>  my box (to test the thing a little).

Davide,

Please CC me on all kernel-userland API changes, so that I can watch
for changes that may be needed for man-pages.

Cheers,

Michael

-- 
I'll likely only see replies if they are CCed to mtk.manpages at gmail dot com
