Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbYBKKMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbYBKKMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYBKKMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:12:25 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46696 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbYBKKMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:12:24 -0500
Subject: Re: [PATCH][RESEND] drivers/base: export
	(un)register_memory_notifier
From: Dave Hansen <haveblue@us.ibm.com>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: Greg KH <greg@kroah.com>, Jan-Bernd Themann <themann@de.ibm.com>,
       Thomas Klein <osstklei@de.ibm.com>, netdev <netdev@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>,
       Christoph Raisch <raisch@de.ibm.com>
In-Reply-To: <200802111049.05478.ossthema@de.ibm.com>
References: <200802111049.05478.ossthema@de.ibm.com>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 02:12:23 -0800
Message-Id: <1202724743.8276.2.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-11 at 10:49 +0100, Jan-Bernd Themann wrote:
> are you the right person to address this patch to?

You might want to check the top of the file. ;)

> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -52,11 +52,13 @@ int register_memory_notifier(struct notifier_block *nb)
>  {
>          return blocking_notifier_chain_register(&memory_chain, nb);
>  }
> +EXPORT_SYMBOL(register_memory_notifier);
>  
>  void unregister_memory_notifier(struct notifier_block *nb)
>  {
>          blocking_notifier_chain_unregister(&memory_chain, nb);
>  }
> +EXPORT_SYMBOL(unregister_memory_notifier);

Is there a particular reason these can't be GPL?

-- Dave

