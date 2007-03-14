Return-Path: <linux-kernel-owner+w=401wt.eu-S1161128AbXCNLMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161128AbXCNLMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 07:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161130AbXCNLMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 07:12:06 -0400
Received: from ns1.suse.de ([195.135.220.2]:50911 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161128AbXCNLMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 07:12:05 -0400
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org,
       pmarques@grupopie.com
Subject: Re: [PATCH] Race between cat /proc/kallsyms and rmmod
References: <20070314111328.GA6807@localhost.sw.ru>
From: Andi Kleen <andi@firstfloor.org>
Date: 14 Mar 2007 13:11:06 +0100
In-Reply-To: <20070314111328.GA6807@localhost.sw.ru>
Message-ID: <p73odmw81ph.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@sw.ru> writes:
> 
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -40,6 +40,8 @@ extern const u16 kallsyms_token_index[] 
>  
>  extern const unsigned long kallsyms_markers[] __attribute__((weak));
>  
> +extern struct mutex module_mutex;

No externs in .c files

-Andi
