Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZGBXL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZGBXL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZGBXLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:11:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZGBXLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:11:50 -0400
Date: Fri, 3 Jul 2009 01:11:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Horst Schirmeier <horst@schirmeier.com>
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] doc: missing value 2 for randomize-va-space
In-Reply-To: <20090702152338.GU26384@quickstop.soohrt.org>
Message-ID: <alpine.LNX.2.00.0907030109191.4994@wotan.suse.de>
References: <20090702152338.GU26384@quickstop.soohrt.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009, Horst Schirmeier wrote:

> The documentation for /proc/sys/kernel/* does not mention the possible
> value 2 for randomize-va-space (but already mentions what it does).

Hmm, while you are at it ...

>  Documentation/sysctl/kernel.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 322a00b..b2af4ef 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -310,7 +310,7 @@ that support this feature.
>      loaded to random addresses. Also for PIE-linked binaries, the location
>      of code start is randomized.
>  
> -    With heap randomization, the situation is a little bit more
> +2 - With heap randomization, the situation is a little bit more
>      complicated.
>      There a few legacy applications out there (such as some ancient

... would you please fix this typo/grammo as well? (There a few ...)

>      versions of libc.so.5 from 1996) that assume that brk area starts

Also, the text itself doesn't seem to be super-clear ... namely, it 
describes what CONFIG_COMPAT_BRK is about, but doesn't really clarify how 
exactly does this correlate with randomize_va_space == 2. Would you mind 
also fixing this bit?

Thanks,

-- 
Jiri Kosina
SUSE Labs
