Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbYHOMrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbYHOMrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYHOMrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:47:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:53035 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbYHOMrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:47:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fEnrHh3VreQ//B8QmUDMKcGdRhXSmV0eFfqqiknPfa+udYctIfWlr8HExsa8Rk7Dox
         Cs7vIjKgyesNvSBPdQQOysMBKk+0tu1owx/gpyl7P3wSGGe7rY7vMruwFrp/3zgMIuiP
         mJ1C+T/SuSTyx5PEgDYDcqoUs6sxFHE10xCOw=
Message-ID: <8bd0f97a0808150547x3abb3f47ha1438e8e7af1bfe5@mail.gmail.com>
Date: Fri, 15 Aug 2008 08:47:09 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney@kernel.org>
Subject: Re: [PATCH 2/2] Blackfin Serial Driver: Add a debug function to serial driver.
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       "Graf Yang" <graf.yang@analog.com>
In-Reply-To: <1218788617-8302-3-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218788617-8302-1-git-send-email-cooloney@kernel.org>
	 <1218788617-8302-3-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 4:23 AM, Bryan Wu wrote:
> +#ifdef CONFIG_DEBUG_KERNEL
> + ...
> +#else
> +void bfin_serial_debug(const char *fmt, ...)
> +{
> +       return;
> +}
> +EXPORT_SYMBOL(bfin_serial_debug);
> +#endif

it doesnt really make sense to export the symbol or make it available
when debugging is not enabled.
-mike
