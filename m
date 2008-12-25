Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbYLYOnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbYLYOnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYLYOnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:43:47 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:54798 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYLYOnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:43:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=JpUbA2sXaFp24rrBhrsxrfzctTSxfrSj/b1Hs/t29TMVMb2f60xMvQpAniMvFt9g/g
         C/+bsbSMRRFI/ThFw5zThYvRjqUN8z29nfzCnjzDrCPppeveKgn5v9hXm7+tKNViQ8/e
         OLUlGltJQwZMJxUU/P8+btE5FydfMEGy4x79w=
Message-ID: <2f11576a0812250643s25a79de6q205ae3b0a7d63f06@mail.gmail.com>
Date: Thu, 25 Dec 2008 23:43:45 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH for -tip] irq: for_each_irq_desc() makes simplify
Cc: "Ingo Molnar" <mingo@elte.hu>, "Yinghai Lu" <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081225143128.GA13388@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081225200020.50F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081225213640.50F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081225214057.50F6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081225131000.GA7510@localhost>
	 <2f11576a0812250545g1967467fy568099affdaa6c35@mail.gmail.com>
	 <20081225143128.GA13388@localhost>
X-Google-Sender-Auth: 84d4da0f6ca2d613
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> | "if (!desc) " mean this irqno don't have irq description.
> | so I think this name imply mean skipping no irq desctiption element.
> |
> | Actually, on CONFIG_SPARSEIRQ, desc is filled in dynamically after booting.
> | then "defined" is a bit misleading word.
> |
>
> So if I would need to iterate over all descriptors including empty
> I need to type all this long for(;;) form again?

We already have for_each_irq_nr() for this purpose ;-)

> For me for_each_irq_desc
> implies to iterate over each irq_desc allocated regardles of internal
> descriptor data. For example in list_struct we have a special test if
> entry is empty or not. So I think hiding details is not that good (and
> that is why I was asking for more descriptive macro name). BUT if it
> really supposed to behave like that then I don't object :)
