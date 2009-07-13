Return-Path: <linux-kernel-owner+w=401wt.eu-S1751009AbZGMED4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009AbZGMED4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 00:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZGMEDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 00:03:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:2590 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZGMEDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 00:03:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y96cjmqiJGoFgbuckcHowDzgYwTAiPDr/+Ru2Z4UzX6n4CKai1QHcuFmn/zHFTzHSS
         LfB6sZLr4+aQWUvEO7/KNXxiS49xjZVurx5+GPRKWmR5R0ikC81IpyY5PyDGkgh7GS/t
         oIvjeZcaoq4QcMGffm2vwBct0MvLe0Vp557Xk=
Date: Sun, 12 Jul 2009 21:03:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Giuseppe <g.mazzotta@iragan.com>
Cc: mitr@volny.cz, stable@kernel.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] wistron_btns DMI info to recognize Maxdata Pro
	7000 notebooks
Message-ID: <20090713040347.GG10819@dtor-d630.eng.vmware.com>
References: <4A50E086.5090206@iragan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A50E086.5090206@iragan.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 07:19:02PM +0200, Giuseppe wrote:
> This patch adds DMI recognition information to automatically load the  
> correct layout for the Maxdata Pro 7000X/DX notebook models. Such  
> notebooks are clones of Fujitsu Amilo V2000, the hook for the v2000 is  
> being used and I have tested that perfectly works.
>
> The immediate result of integrating this patch is that the five special  
> buttons will work on these specific notebook models and that the RF  
> killswitch will not be activated after suspend. This patch definitively  
> obsoletes the fsam7400 module which I was still needing to enable wifi  
> and to fix the RF killswitch suspend problem; in the current 2.6.30  
> kernel it is necessary to load the wistron_btns module with options  
> 'force=1 keymap=1557/MS2141', which was not anyway a complete workaround.
>
> Signed-off-by: Giuseppe Mazzotta <g.mazzotta@iragan.com>
>

Applied, thank you Giuseppe. BTW, your mailer converts tabs to spaces
and line-wraps the mails, you might want to look into fixing that,

Thanks!

-- 
Dmitry
