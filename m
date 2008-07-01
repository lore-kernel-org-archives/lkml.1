Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYGAMGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYGAMGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYGAMGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:06:05 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:46443 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbYGAMGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:06:04 -0400
X-Greylist: delayed 1546 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2008 08:06:04 EDT
Date: Tue, 1 Jul 2008 21:40:16 +1000
From: Simon Horman <horms@verge.net.au>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com
Subject: Re: [PATCH] x86: Fix documentation bug about relocatability
Message-ID: <20080701114015.GA11207@verge.net.au>
References: <1214510118-21405-1-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214510118-21405-1-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 09:55:18PM +0200, Bernhard Walle wrote:
> This patch fixes a small bug in documentation: x86_64 also has now
> the ability to build a relocatable kernel.
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>

Acked-by: mon Horman <horms@verge.net.au>

> ---
>  Documentation/kdump/kdump.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
> index b8e52c0..9691c7f 100644
> --- a/Documentation/kdump/kdump.txt
> +++ b/Documentation/kdump/kdump.txt
> @@ -109,7 +109,7 @@ There are two possible methods of using Kdump.
>  2) Or use the system kernel binary itself as dump-capture kernel and there is
>     no need to build a separate dump-capture kernel. This is possible
>     only with the architecutres which support a relocatable kernel. As
> -   of today i386 and ia64 architectures support relocatable kernel.
> +   of today, i386, x86_64 and ia64 architectures support relocatable kernel.
>  
>  Building a relocatable kernel is advantageous from the point of view that
>  one does not have to build a second kernel for capturing the dump. But
> -- 
> 1.5.6
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

-- 
Horms

