Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbZBORC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbZBORC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 12:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZBORCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 12:02:19 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:63448 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbZBORCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 12:02:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OOj7pTwbfd8nTQlVw0Jj24IbyOf0wF1OL4920LzgrpFTdp4wWHMgpgj/KaAWtvHU7X
         ABLC63hcG2deH8FV8WJCcim6wO4h8E9ASZBX81WY1udyB3JFlvPqQp7HaoQJCXMNWppC
         SNkjvEtp4U8jwQ2xjhelxJl+DIBx0c2fmp1uU=
Date: Sun, 15 Feb 2009 18:02:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Poking ieee80211_default_rc_algo causes kernel lockups
Message-ID: <20090215170214.GK5835@nowhere>
References: <slrngpgfil.5gc.sitsofe@sitsofe.eeepc.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <slrngpgfil.5gc.sitsofe@sitsofe.eeepc.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 04:09:57PM +0000, Sitsofe Wheeler wrote:
> Hi,
> 
> As mentioned on
> http://groups.google.com/group/fa.linux.kernel/browse_frm/thread/d4a6ce26360613fa/b362792a2debced6?#b362792a2debced6
> , poking /sys/module/mac80211/parameters/ieee80211_default_rc_algo and
> then trying to read values back is currently causing the kernel to go
> funny. E.g.
> echo blah > /sys/module/mac80211/parameters/ieee80211_default_rc_algo
> cat /sys/module/mac80211/parameters/ieee80211_default_rc_algo
> 
> Causes 2.6.29rc5 on my EeePC 900 to lock up.
> 
> -- 
> Sitsofe


Hi,

I'm currently building a 2.6.29-rc5 with CONFIG_MAC80211 enabled
to test it.

Could you please enable the CONFIG_DETECT_SOFTLOCKUP option in your kernel?
It's on Kernel Hacking > Detect Soft Lockups.
With some chances you will have a relevant stacktrace of the lockup, in case
I couldn't reproduce it.

 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

