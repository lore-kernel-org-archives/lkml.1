Return-Path: <linux-kernel-owner+w=401wt.eu-S974630AbXHMS7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S974630AbXHMS7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032733AbXHMSyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:54:50 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47613 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S939438AbXHMSyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:54:47 -0400
Date: Mon, 13 Aug 2007 20:54:31 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       sam@ravnborg.org, zippel@linux-m68k.org, vincent.legoll@gmail.com
Subject: Re: [PATCH] kconfig: update kconfig-language text
Message-ID: <20070813185431.GD18945@stusta.de>
References: <20070813113809.9a715e75.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070813113809.9a715e75.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 11:38:09AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add kconfig-language docs for mainmenu, def_bool[ean],
> and def_tristate.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
> ---
>  Documentation/kbuild/kconfig-language.txt |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> --- linux-2.6.23-rc3.orig/Documentation/kbuild/kconfig-language.txt
> +++ linux-2.6.23-rc3/Documentation/kbuild/kconfig-language.txt
> @@ -77,6 +77,11 @@ applicable everywhere (see syntax).
>    Optionally, dependencies only for this default value can be added with
>    "if".
>  
> +- type definition + default value:
> +	"def_bool"/"def_boolean"/"def_tristate" <expr> ["if" <expr>]
>...

Should the redundant and unused def_boolean be documented or removed?

I'd prefer the latter.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

