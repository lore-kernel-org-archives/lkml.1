Return-Path: <linux-kernel-owner+w=401wt.eu-S1031395AbXEDQxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031395AbXEDQxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031418AbXEDQwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:52:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:13257 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031395AbXEDQwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:52:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JpjUusOULDOi3UghPT4M8LRMCdY606uQMhrNyCzYoF3PZTV3uGW9WGwmir0m0EMoyAF2K1zDlkEiOkRsfk0RfEWpX+jgqtyQtANvkrWGFgboZn/YCGFT3dT8jjbs/mgQskYLlawLsfZ2SW4e5QE3VLmijFArSV9dAL84HB7clUk=
Message-ID: <463B64D1.9080007@gmail.com>
Date: Fri, 04 May 2007 18:52:33 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] KBUILD: Drop tty.h and isicom.h from include/linux/Kbuild.
References: <Pine.LNX.4.64.0705041242490.27723@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705041242490.27723@localhost.localdomain>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Alan Cox

Robert P. J. Day napsal(a):
> Drop the entries for tty.h and isicom.h from the include/linux/Kbuild
> file, since "make headers_install" just generates empty files for
> them.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

Acked-by: Jiri Slaby <jirislaby@gmail.com> (isicom part)

Unsure for tty.h -- won't this break too much of apps' builds?

> ---
> 
> i've submitted a patch to do this at least twice before.  is there
> some reason those empty generated header are being so tenacious?
> 
> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index 4ff0f57..63de91a 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -239,7 +239,6 @@ unifdef-y += ipv6_route.h
>  unifdef-y += isdn.h
>  unifdef-y += isdnif.h
>  unifdef-y += isdn_ppp.h
> -unifdef-y += isicom.h
>  unifdef-y += jbd.h
>  unifdef-y += joystick.h
>  unifdef-y += kdev_t.h
> @@ -320,7 +319,6 @@ unifdef-y += sysctl.h
>  unifdef-y += tcp.h
>  unifdef-y += time.h
>  unifdef-y += timex.h
> -unifdef-y += tty.h
>  unifdef-y += types.h
>  unifdef-y += udf_fs_i.h
>  unifdef-y += udp.h

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
