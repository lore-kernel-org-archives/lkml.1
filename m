Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539Ab0AVKLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0AVKLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 05:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492Ab0AVKLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 05:11:15 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:57919 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab0AVKLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 05:11:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Hslb7PWtCAg83kQCWxJIhvTWsZLZowS0Czm8vibISieqRdN2wQKX+9AIzH5z1cY3Z0
         l6uw5JwkN+68Res8ENRCXRND5lMIIh4fAF1d57BnryzOkvipJNExN6jDU3b1F/K/XDfo
         ZjKgtN0F2fX+ccPPog1gDGQ5HKNxA8EKhSuVo=
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was:
 Re: [linux-pm] Memory allocations in .suspend became very unreliable)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100122103830.6C09.A69D9226@jp.fujitsu.com>
References: <201001212121.50272.rjw@sisk.pl>
	 <20100122100155.6C03.A69D9226@jp.fujitsu.com>
	 <20100122103830.6C09.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 12:11:07 +0200
Message-ID: <1264155067.15930.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 10:42 +0900, KOSAKI Motohiro wrote: 
> > > > Probably we have multiple option. but I don't think GFP_NOIO is good
> > > > option. It assume the system have lots non-dirty cache memory and it isn't
> > > > guranteed.
> > > 
> > > Basically nothing is guaranteed in this case.  However, does it actually make
> > > things _worse_?  
> > 
> > Hmm..
> > Do you mean we don't need to prevent accidental suspend failure?
> > Perhaps, I did misunderstand your intention. If you think your patch solve
> > this this issue, I still disagree. but If you think your patch mitigate
> > the pain of this issue, I agree it. I don't have any reason to oppose your
> > first patch.
> 
> One question. Have anyone tested Rafael's $subject patch? 
> Please post test result. if the issue disapper by the patch, we can
> suppose the slowness is caused by i/o layer.

I did.

As far as I could see, patch does solve the problem I described.

Does it affect speed of suspend? I can't say for sure. It seems to be
the same.

Best regards,
Maxim Levitsky

