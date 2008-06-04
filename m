Return-Path: <linux-kernel-owner+w=401wt.eu-S1758370AbYFDHb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbYFDHb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 03:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYFDHbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 03:31:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:17404 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYFDHbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 03:31:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lu6d3KfofOzFpVpfUN96yOa80SgHDgXr1q50QAmeq18xJEB1nE/QJTssgohViu/WrR5dvi/YiWUuAvoCy4VrkotEDymbETBg8+UA/EsULL/GgENwVk30Xayy16jF1mz+672IB0dezp7MCjx+nheTA5z+hTh7Ar447PKIUzXbbTE=
Message-ID: <cd73a99e0806040031s13e6b4a5ndc5fb3d931e1945f@mail.gmail.com>
Date: Wed, 4 Jun 2008 09:31:50 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: AT91SAM9/CAP9 watchdog driver
Cc: wim@iguana.be, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080603142316.c53b32b2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cd73a99e0806010940g501f11b4jcb7caf6acfd5c49f@mail.gmail.com>
	 <20080603142316.c53b32b2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Andrew,

>> +             return 0;
>
> That looks like the wrong return value?

Since the watchdog registers are Write-Once, if the user does not
specify a "wdt_timeout" parameter we'd still like the driver to load
even if it's not enabled.
The user can then always use ioctl(WDIOC_SETTIMEOUT:) to set the timeout later.


Regards,
  Andrew Victor
