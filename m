Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbZAZRNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbZAZRNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZAZRN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:13:28 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:19245 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZAZRN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:13:27 -0500
Message-ID: <497DEF1E.2060504@oracle.com>
Date: Mon, 26 Jan 2009 09:13:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Teemu Likonen <tlikonen@iki.fi>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH v2] Documentation: update CodingStyle tips for Emacs users
References: <87skn6t39o.fsf@iki.fi> <1232989279-7452-1-git-send-email-tlikonen@iki.fi>
In-Reply-To: <1232989279-7452-1-git-send-email-tlikonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.497DEF25.0261:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teemu Likonen wrote:
> With the previous Emacs tips example the kernel style was made available
> for files in the kernel-tree only. This patch updates the tip to add a
> separate cc-mode indent style ("linux-tabs-only"). This makes it easy to
> switch between different indent styles and also makes the kernel style
> easily available for any filetype mode (c++, awk, ...) that is managed
> by the Emacs cc-mode.
> 
> Signed-off-by: Teemu Likonen <tlikonen@iki.fi>
> ---
>  Documentation/CodingStyle |   15 +++++++++++----
>  1 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 1875e50..7b5762e 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -483,6 +483,16 @@ values.  To do the latter, you can stick the following in your .emacs file:
>      (* (max steps 1)
>         c-basic-offset)))
>  
> +(add-hook 'c-mode-common-hook
> +          (lambda ()
> +            ;; Add kernel style
> +            (c-add-style
> +             "linux-tabs-only"
> +             '("linux" (c-offsets-alist
> +                        (arglist-cont-nonempty
> +                         c-lineup-gcc-asm-reg
> +                         c-lineup-arglist-tabs-only))))))
> +
>  (add-hook 'c-mode-hook
>            (lambda ()
>              (let ((filename (buffer-file-name)))
> @@ -490,10 +500,7 @@ values.  To do the latter, you can stick the following in your .emacs file:
>                (when (and filename
>                           (string-match "~/src/linux-trees" filename))
>                  (setq indent-tabs-mode t)
> -                (c-set-style "linux")
> -                (c-set-offset 'arglist-cont-nonempty
> -                              '(c-lineup-gcc-asm-reg
> -                                c-lineup-arglist-tabs-only))))))
> +                (c-set-style "linux-tabs-only")))))
>  
>  This will make emacs go better with the kernel coding style for C
>  files below ~/src/linux-trees.


I don't see Dan's patch merged into this one... ?

-- 
~Randy
