Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYIENGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYIENGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 09:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYIENGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 09:06:25 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:60193 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbYIENGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 09:06:24 -0400
X-Auth-Info: jfRuzoEF3zWDKk35DxUY8mozr454C8ymE0hcORLNnfA=
X-Auth-Info: jfRuzoEF3zWDKk35DxUY8mozr454C8ymE0hcORLNnfA=
X-Auth-Info: jfRuzoEF3zWDKk35DxUY8mozr454C8ymE0hcORLNnfA=
X-Auth-Info: jfRuzoEF3zWDKk35DxUY8mozr454C8ymE0hcORLNnfA=
To: Ilya Yanok <yanok@emcraft.com>
cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yuri Tikhonov <yur@emcraft.com>
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH] ASYNC_TX: fix the bug in async_tx_run_dependencies
Mime-version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <1220478231-8725-1-git-send-email-yanok@emcraft.com>
References: <1220478231-8725-1-git-send-email-yanok@emcraft.com>
Comments: In-reply-to Ilya Yanok <yanok@emcraft.com>
   message dated "Thu, 04 Sep 2008 01:43:51 +0400."
Date: Fri, 05 Sep 2008 15:06:22 +0200
Message-Id: <20080905130622.4C497248B8@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ilya &Yrui,

In message <1220478231-8725-1-git-send-email-yanok@emcraft.com> you wrote:
> 
> Should clear the next pointer of the TX if we are sure that the
> next TX (say NXT) will be submitted to the channel too. Overwise,
> we break the chain of descriptors, because we lose the information
> about the next descriptor to run. So next time, when invoke
> async_tx_run_dependencies() with TX, it's TX->next will be NULL, and
> NXT will be never submitted.
> 
> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
> ---
>  crypto/async_tx/async_tx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

What about this patch? SHould it be applied to our repository?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
The use of Microsoft crippleware systems is a sin that  carries  with
it its own punishment.
         -- Tom Christiansen in <6bo3fr$pj8$5@csnews.cs.colorado.edu>
