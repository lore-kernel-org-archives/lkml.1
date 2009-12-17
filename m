Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbZLQMBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbZLQMBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbZLQMBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:01:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbZLQMBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:01:18 -0500
Message-ID: <4B2A1D8C.10306@suse.cz>
Date: Thu, 17 Dec 2009 13:01:16 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [resend][GIT PULL] kbuild updates for 2.6.33
References: <20091216222816.GA8397@sepie.suse.cz> <20091217131753.c09c941e.sfr@canb.auug.org.au>
In-Reply-To: <20091217131753.c09c941e.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.12.2009 03:17, Stephen Rothwell wrote:
> Hi Linus, Michal,
> 
> On Wed, 16 Dec 2009 23:28:16 +0100 Michal Marek <mmarek@suse.cz> wrote:
>>
>>       kbuild: move autoconf.h to include/generated
> 
> Since Rusty's module changes are now upstream, the above change requires
> this fixup which I have been carrying in linux-next for some time:

Ah, thanks, I forgot about this one. I rebased the for-next branch now
and added your patch. I didn't touch the for-33 branch in order to not
invalidate the pull request.


> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 12 Nov 2009 18:33:17 +1100
> Subject: [PATCH] modpost: autoconf.h has moved to include/generated
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Michal Marek <mmarek@suse.cz>.

Michal


> ---
>  scripts/mod/modpost.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index f6be2e9..769ea95 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -15,7 +15,7 @@
>  #include <stdio.h>
>  #include <ctype.h>
>  #include "modpost.h"
> -#include "../../include/linux/autoconf.h"
> +#include "../../include/generated/autoconf.h"
>  #include "../../include/linux/license.h"
>  
>  /* Some toolchains use a `_' prefix for all user symbols. */

