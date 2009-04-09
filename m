Return-Path: <linux-kernel-owner+w=401wt.eu-S1764150AbZDIGmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764150AbZDIGmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 02:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbZDIGmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 02:42:44 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:37895 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbZDIGmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 02:42:43 -0400
Date: Thu, 9 Apr 2009 08:44:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: tj@kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12]: sparc64: Use new dynamic per-cpu allocator.
Message-ID: <20090409064447.GB14255@uranus.ravnborg.org>
References: <20090408.223758.81953207.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408.223758.81953207.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 10:37:58PM -0700, David Miller wrote:
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  arch/sparc/Kconfig         |    3 +
>  arch/sparc/kernel/smp_64.c |  165 +++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 159 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index cc12cd4..2185cf9 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -93,6 +93,9 @@ config AUDIT_ARCH
>  config HAVE_SETUP_PER_CPU_AREA
>  	def_bool y if SPARC64
>  
> +config HAVE_DYNAMIC_PER_CPU_AREA
> +	def_bool y if SPARC64
> +

Not related to this specific patch - but I wonder if there
is any good reason these HAVE_ varaibles do not follow the
normal pattern with one definition
and users using select to enable it.

	Sam
