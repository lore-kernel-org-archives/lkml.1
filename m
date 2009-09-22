Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbZIVOmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbZIVOmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZIVOmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:42:14 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54053 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZIVOmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:42:13 -0400
Date: Tue, 22 Sep 2009 16:42:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, linux-modules@vger.org
Subject: Re: [PATCH 1/4] module: extract __ExPORT_SYMBOL from module.h into
	mod_export.h
Message-ID: <20090922144216.GA29949@merkur.ravnborg.org>
References: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk> <1253626718-18887-2-git-send-email-alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253626718-18887-2-git-send-email-alan-jenkins@tuffmail.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 02:38:35PM +0100, Alan Jenkins wrote:
> The new header mod_export.h allows __EXPORT_SYMBOL to be used without
> pulling in any function or variable declarations.  It will be used by
> the build system to help sort the list of symbols exported by the
> kernel.
> 
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> ---
>  include/linux/mod_export.h |   74 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/module.h     |   63 +------------------------------------
>  2 files changed, 75 insertions(+), 62 deletions(-)
>  create mode 100644 include/linux/mod_export.h
> 
> diff --git a/include/linux/mod_export.h b/include/linux/mod_export.h
> new file mode 100644
> index 0000000..3c51b9c
> --- /dev/null
> +++ b/include/linux/mod_export.h
> @@ -0,0 +1,74 @@
> +#ifndef LINUX_MOD_EXPORT_H
> +#define LINUX_MOD_EXPORT_H
> +
> +#include <linux/compiler.h>
> +#include <asm/module.h>

Do you need this include?

	Sam
