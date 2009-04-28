Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZD1EmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZD1EmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 00:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZD1El5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 00:41:57 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53688 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZD1El4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 00:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JRb4LH3kYdsER04tnapkC5RPKAimbzKlrA+5uFXjdibfiSkxiJ5Zi1lxkjiR7uZg7U
         eKbKPLfES4FavA/WnRHfXEiOm9qak0TitDn7hBBsZ4ol1davpM8AzzgEXRm+emmo8bg5
         qYRtKwLwS5aMpy1ouc4SrKm81zNDsyhCnR4Ys=
MIME-Version: 1.0
In-Reply-To: <1240864388-26315-13-git-send-email-tabbott@mit.edu>
References: <1240864388-26315-1-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-5-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-6-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-7-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-8-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-9-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-10-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-11-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-12-git-send-email-tabbott@mit.edu>
	 <1240864388-26315-13-git-send-email-tabbott@mit.edu>
Date: Tue, 28 Apr 2009 08:41:54 +0400
X-Google-Sender-Auth: 25213c19ff8bb576
Message-ID: <aa79d98a0904272141y1aff7689ld9a67c18c6579336@mail.gmail.com>
Subject: Re: [PATCH 12/14] mn10300: Drop unused .data.idt section.
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Tim Abbott <tabbott@mit.edu>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@mit.edu>, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/09, Tim Abbott <tabbott@mit.edu> wrote:
> Since nothing gets put into .data.idt on this architecture, eliminate
> it from the linker script.
>
> This change was apparently proposed previously:
> <http://lkml.indiana.edu/hypermail/linux/kernel/0802.2/2538.html>
>
> CCing the author and people who acked that patch in case there was a
> reason it wasn't applied.
>
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/mn10300/kernel/vmlinux.lds.S |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/arch/mn10300/kernel/vmlinux.lds.S
> b/arch/mn10300/kernel/vmlinux.lds.S
> index 6ad0fa8..364250f 100644
> --- a/arch/mn10300/kernel/vmlinux.lds.S
> +++ b/arch/mn10300/kernel/vmlinux.lds.S
> @@ -59,9 +59,6 @@ SECTIONS
>    . = ALIGN(PAGE_SIZE);
>    __nosave_end = .;
>
> -  . = ALIGN(PAGE_SIZE);
> -  .data.page_aligned : { *(.data.idt) }
> -
>    . = ALIGN(32);
>    .data.cacheline_aligned : { *(.data.cacheline_aligned) }
>
> --
> 1.6.2.1
>
>

Thanks Tim!
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
