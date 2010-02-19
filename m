Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0BSSGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 13:06:50 -0500
Received: from xenotime.net ([72.52.64.118]:43745 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753768Ab0BSSGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 13:06:47 -0500
Message-ID: <4B7ED334.5000603@xenotime.net>
Date: Fri, 19 Feb 2010 10:06:44 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <abelay@mit.edu>
Subject: Re: [PATCH v1 2/7] vsprintf: clarify comments for printf_spec flags
References: <20100219175655.9199.30691.stgit@bob.kio> <20100219175828.9199.12642.stgit@bob.kio>
In-Reply-To: <20100219175828.9199.12642.stgit@bob.kio>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/10 09:58, Bjorn Helgaas wrote:
> 
> Add clues about what the SMALL and SPECIAL flags do.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---
> 
>  lib/vsprintf.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 3b8aeec..212d047 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -381,8 +381,8 @@ static noinline char *put_dec(char *buf, unsigned long long num)
>  #define PLUS	4		/* show plus */
>  #define SPACE	8		/* space if plus */
>  #define LEFT	16		/* left justified */
> -#define SMALL	32		/* Must be 32 == 0x20 */
> -#define SPECIAL	64		/* 0x */
> +#define SMALL	32		/* use lowercase in hex (must be 32 == 0x20) */
> +#define SPECIAL	64		/* prefix hex with "0x", octal with "0 */

might as well do:						octal with "0" */


>  
>  enum format_type {
>  	FORMAT_TYPE_NONE, /* Just a string part */


-- 
~Randy
