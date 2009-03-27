Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbZC0HtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbZC0HtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZC0Hs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:48:58 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:55450 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbZC0Hs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:48:58 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] vfat: Note the NLS requirement
References: <20090326205256.5293.35764.stgit@localhost.localdomain>
Date: Fri, 27 Mar 2009 16:48:50 +0900
In-Reply-To: <20090326205256.5293.35764.stgit@localhost.localdomain> (Alan
	Cox's message of "Thu, 26 Mar 2009 20:53:00 +0000")
Message-ID: <87vdpv5rtp.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

Thanks. Looks good to me.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Please apply.

> Close bug #4754
>
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
>
>  fs/fat/Kconfig |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
>
> diff --git a/fs/fat/Kconfig b/fs/fat/Kconfig
> index d0a69ff..182f9ff 100644
> --- a/fs/fat/Kconfig
> +++ b/fs/fat/Kconfig
> @@ -95,3 +95,6 @@ config FAT_DEFAULT_IOCHARSET
>  	  Note that "utf8" is not recommended for FAT filesystems.
>  	  If unsure, you shouldn't set "utf8" here.
>  	  See <file:Documentation/filesystems/vfat.txt> for more information.
> +
> +	  Enable any character sets you need in File Systems/Native Language
> +	  Support.
>

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
