Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbYJ0R1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbYJ0R1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYJ0R1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:27:08 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45542 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977AbYJ0R1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:27:07 -0400
Message-Id: <1225128425.8714.1281501519@webmail.messagingengine.com>
X-Sasl-Enc: 5yRz46ug7eU9vIv6gEcy7WXo5JjmBzfckSEnwEx4eqmO 1225128425
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Neil Horman" <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, mingo@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, nhorman@tuxdriver.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20081023144006.GA14149@hmsendeavour.rdu.redhat.com>
Subject: Re: [PATCH] x86: unify appropriate bits from dumpstack_32 and
 dumpstack_64
In-Reply-To: <20081023144006.GA14149@hmsendeavour.rdu.redhat.com>
Date: Mon, 27 Oct 2008 18:27:05 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 10:40:06 -0400, "Neil Horman"
<nhorman@tuxdriver.com> said:
> Hey all-
> 	As promised, now that dumpstack_32 and dumpstack_64 have so many bits in
> common, we should merge the in-sync bits into a common file, to prevent them
> from diverging again.  This patch removes bits which are common between
> dumpstack_32.c and dumpstack_64.c and places them in a common dumpstack.c
> which is built for both 32 and 64 bit arches.  
> 
> Regards
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

A bit late, maybe, but if it matters:

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

Thanks Neil!

> 
>  Makefile       |    2 
>  dumpstack.c    |  319 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  dumpstack.h    |   39 ++++++
>  dumpstack_32.c |  294 ----------------------------------------------------
>  dumpstack_64.c |  285 --------------------------------------------------
>  5 files changed, 363 insertions(+), 576 deletions(-)
> 
> [...]
> 
> /***************************************************
>  *Neil Horman
>  *nhorman@tuxdriver.com
>  *gpg keyid: 1024D / 0x92A74FA1
>  *http://pgp.mit.edu
>  ***************************************************/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Choose from over 50 domains or use your own

