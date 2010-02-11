Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0BKR0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 12:26:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:21633 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0BKR0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:26:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GQbNdhByF6LfHvalj+8oPQIkWzbrI+o+3fzgvPbApamUrAmoRcHeaD1hoZd2Cv9Iab
         9iSpP+YKJX5W6m422B++Xub91AWZowqmvm/KiHqtYXbi/eve7ucO50b9eWkFPszgn3ba
         /3ytRE8VhxZtSTDGziwQnaAT8lv2q7nbxoEbE=
Subject: Re: [PATCH 2/6] DMFE: move pci ID definitions into pci_ids.h and
 clean up the code
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       maxim-levitsky@gmail.com
In-Reply-To: <20100210.132201.21689811.davem@davemloft.net>
References: <1265487542-4447-1-git-send-email-maximlevitsky@gmail.com>
	 <1265487542-4447-3-git-send-email-maximlevitsky@gmail.com>
	 <20100210.131849.237007566.davem@davemloft.net>
	 <20100210.132201.21689811.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Feb 2010 19:25:22 +0200
Message-ID: <1265909122.9788.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 13:22 -0800, David Miller wrote: 
> From: David Miller <davem@davemloft.net>
> Date: Wed, 10 Feb 2010 13:18:49 -0800 (PST)
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Date: Sat,  6 Feb 2010 22:18:58 +0200
> > 
> >> Signed-off-by: Maxim Levitsky <maxim-levitsky@gmail.com>
> > 
> > We don't add new definitions to pci_ids.h that will only
> > be used in a single driver.
No problem!
Didn't know about that.

> > 
> > Instead, we just use the raw constants (if it's only referenced once,
> > say in the PCI ID table for the driver) or using local definitions
> > (if used multiple times in the driver).
> 
> BTW, the rest of your patch set is likely to not apply
> correctly after you fix this patch up.  So at a minimum
> you'll need to resubmit this whole set after fixing
> patch #2.
I agree with that completely.



> 
> In fact I would recommend that you seperate the bug
> fixes from all of the massive cleanups.
> 
> Get the bug fixes, especially the PCI READ MULTIPLE
> disable one, into net-2.6
> 
> Then afterwards you can do all of the cleanups against
> net-next-2.6 when the bug fixes propagate there.
This is good idea too.
I also will split the cleanups, because looking back at massive patch I
understand that it is not good for review.


> 
> Thank you!

Thanks too.

Best regards,
Maxim Levitsky

