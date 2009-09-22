Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbZIVEnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbZIVEnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 00:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbZIVEnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 00:43:13 -0400
Received: from [195.41.46.235] ([195.41.46.235]:60329 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbZIVEnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 00:43:13 -0400
Date: Tue, 22 Sep 2009 06:43:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Am?rico Wang <xiyou.wangcong@gmail.com>, Caveh Jalali <ecaveh@gmail.com>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] warn about use of uninstalled kernel headers
Message-ID: <20090922044310.GA29208@merkur.ravnborg.org>
References: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com> <2375c9f90909171849n429bc474heabdc4d4fd064226@mail.gmail.com> <20090918045259.GA23333@merkur.ravnborg.org> <200909211637.12983.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909211637.12983.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 04:37:12PM +0200, Arnd Bergmann wrote:
> User applications frequently hit problems when they try to use
> the kernel headers directly, rather than the exported headers.
> 
> This adds an explicit warning for this case, and points to
> a URL holding an explanation of why this is wrong and what
> to do about it.

Like the idea.

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/linux/kernel.h     |    6 ++++++
>  scripts/headers_install.pl |    2 +-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index d6320a3..f392d72 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -656,6 +656,12 @@ extern int do_sysinfo(struct sysinfo *info);
>  
>  #endif /* __KERNEL__ */
>  
> +#ifndef __EXPORTED_HEADERS__
But why do we need this "__EXPORTED_HEADERS__" thing?

?

	Sam
