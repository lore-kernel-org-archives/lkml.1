Return-Path: <linux-kernel-owner+w=401wt.eu-S1764219AbYBANa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764219AbYBANa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756979AbYBANaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:30:12 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:47471 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbYBANaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:30:11 -0500
Date: Fri, 1 Feb 2008 14:30:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Holger Wolf <wolf@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] latencytop s390 support.
Message-ID: <20080201133013.GC13251@uranus.ravnborg.org>
References: <20080201130811.GB29660@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201130811.GB29660@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 02:08:11PM +0100, Heiko Carstens wrote:
> Subject: [PATCH] latencytop s390 support.
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Cc: Holger Wolf <wolf@linux.vnet.ibm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
> 
> Will go in via the s390 git tree if acceptable.
> 
>  arch/s390/Kconfig             |    3 +++
>  arch/s390/kernel/stacktrace.c |   31 +++++++++++++++++++++++--------
>  2 files changed, 26 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/arch/s390/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/s390/Kconfig
> +++ linux-2.6/arch/s390/Kconfig
> @@ -20,6 +20,9 @@ config LOCKDEP_SUPPORT
>  config STACKTRACE_SUPPORT
>  	def_bool y
>  
> +config HAVE_LATENCYTOP_SUPPORT
> +	def_bool y
> +

Same comment as for the x86 version.
Use:

 config S390
	select HAVE_....

	Sam
