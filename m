Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbZLNWAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbZLNWAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758519AbZLNWAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:00:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758510AbZLNWA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:00:29 -0500
Message-ID: <4B26B587.3030608@redhat.com>
Date: Mon, 14 Dec 2009 17:00:39 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Document awk requirements
References: <20091214213413.GA9816@nb-core2.darkstar.lan>
In-Reply-To: <20091214213413.GA9816@nb-core2.darkstar.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti wrote:
> Hello,
> current -git kernel fails to build with this error message:
> 
>   GEN     arch/x86/lib/inat-tables.c
>   Error: Your awk doesn't support charactor-class.
> 
> mawk is installed; it appears that gawk is required, so:
> ---
> Gnu awk is required for generating arch/x86/lib/inat-tables.c
> 
> Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
> ---

Thank you for adding that :-)

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>


> 
>  Documentation/Changes |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/Changes b/Documentation/Changes
> index 6d0f1ef..53fd218 100644
> --- a/Documentation/Changes
> +++ b/Documentation/Changes
> @@ -49,6 +49,7 @@ o  oprofile               0.9                     # oprofiled --version
>  o  udev                   081                     # udevinfo -V
>  o  grub                   0.93                    # grub --version
>  o  mcelog		  0.6
> +o  Gnu awk                3.1.5                   # awk --version   
>  
>  Kernel compilation
>  ==================

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

