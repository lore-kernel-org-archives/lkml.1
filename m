Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbZIKMS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbZIKMS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 08:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZIKMSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 08:18:25 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:39676 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZIKMSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 08:18:25 -0400
Date: Fri, 11 Sep 2009 14:18:24 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: Re: [PATCH 04/10] s390: Convert BUG() to use unreachable()
Message-ID: <20090911141824.2c7ce579@skybase>
In-Reply-To: <1252627011-2933-4-git-send-email-ddaney@caviumnetworks.com>
References: <4AA991C1.1050800@caviumnetworks.com>
	<1252627011-2933-4-git-send-email-ddaney@caviumnetworks.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009 16:56:45 -0700
David Daney <ddaney@caviumnetworks.com> wrote:

> Use the new unreachable() macro instead of for(;;);
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
> CC: Heiko Carstens <heiko.carstens@de.ibm.com>
> CC: linux390@de.ibm.com
> CC: linux-s390@vger.kernel.org
> ---
>  arch/s390/include/asm/bug.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/s390/include/asm/bug.h b/arch/s390/include/asm/bug.h
> index 7efd0ab..efb74fd 100644
> --- a/arch/s390/include/asm/bug.h
> +++ b/arch/s390/include/asm/bug.h
> @@ -49,7 +49,7 @@
> 
>  #define BUG() do {					\
>  	__EMIT_BUG(0);					\
> -	for (;;);					\
> +	unreachable();					\
>  } while (0)
> 
>  #define WARN_ON(x) ({					\

That seems simple enough ;-)

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

