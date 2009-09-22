Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbZIVHhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbZIVHhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbZIVHhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:37:20 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54892 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZIVHhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:37:19 -0400
Date: Tue, 22 Sep 2009 09:37:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, liqin.gnu@gmail.com
Subject: Re: [PATCH 1/2] score: add head files define in vmlinux.lds.S
Message-ID: <20090922073718.GA29384@merkur.ravnborg.org>
References: <1253601122.27225.2.camel@ad3ser01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253601122.27225.2.camel@ad3ser01>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 02:32:02PM +0800, Chen Liqin wrote:
> 
> Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
> ---
>  arch/score/kernel/vmlinux.lds.S |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/score/kernel/vmlinux.lds.S b/arch/score/kernel/vmlinux.lds.S
> index aab4703..eebcbaa 100644
> --- a/arch/score/kernel/vmlinux.lds.S
> +++ b/arch/score/kernel/vmlinux.lds.S
> @@ -24,6 +24,8 @@
>   */
>  
>  #include <asm-generic/vmlinux.lds.h>
> +#include <asm/thread_info.h>
> +#include <asm/page.h>
>  
>  OUTPUT_ARCH(score)
>  ENTRY(_stext)

Hi Chen.

I assume this is needed to allow Tim's patchset to build.
The preferred way is that you integrate this into the original
patch and apply it to your tree.

We prefer arch specific patches to go in via the arch trees.

I sometime takes patches in via kbuild that touches a lot
of architectures but stuff like like should go in
via you.

For score (and for other archs) I cannot even build test stuff..

	Sam
