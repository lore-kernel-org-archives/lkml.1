Return-Path: <linux-kernel-owner+w=401wt.eu-S1030389AbXCSQp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030389AbXCSQp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030387AbXCSQp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:45:27 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:15442 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030389AbXCSQpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hk/y7UVALwfCiwmeGl16TnU06/lzXcwsMDMnvyt6S9npzLLFf59iQ0/fl7CGqRoSyJxD3Ity7rW9syrUnxL/Kf9eI9/4pWdRs34SZnfY3VmBSuy8bZYQuKnkMGgLg3nNNs1DjhI7+r71bTprg7d57mWYQLf9ppwzYH+ARuLnPfY=
Message-ID: <6bffcb0e0703190945i5f783ea9ie8195fa084b2c13f@mail.gmail.com>
Date: Mon, 19 Mar 2007 17:45:24 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Alan Cox" <alan@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703191836370.22180@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>
	 <45FD8684.4030501@googlemail.com>
	 <6bffcb0e0703190845s6bdc1a65p71937d1dffbf6d9e@mail.gmail.com>
	 <Pine.LNX.4.64.0703191751560.21196@sbz-30.cs.Helsinki.FI>
	 <6bffcb0e0703190929rd118b16u21552da0c81b9f04@mail.gmail.com>
	 <Pine.LNX.4.64.0703191836370.22180@sbz-30.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/07, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> On Mon, 19 Mar 2007, Michal Piotrowski wrote:
> > Yes, revoke-special-mmap-handling.patch is bad.
>
> Aah, the VM_REVOKED flag stomps on VM_CAN_INVALIDATE in -mm. Changing
> VM_REVOKED to 0x10000000 should fix it. I don't have access to kernel tree
> right now so I'll send a patch tomorrow unless someone else beats me to
> it.

Ok, I'll test this and submit the fix to Andrew.

>
>                                 Pekka
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
