Return-Path: <linux-kernel-owner+w=401wt.eu-S965858AbXCLNwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965858AbXCLNwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965856AbXCLNwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:52:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:42158 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965858AbXCLNwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bI2GSBIDNHd93cq2HMPFzrAiea51qp6Y2dL2wKGmXVHlbC3AjgpzAh5t52ZWa7/kTNDmWAxMFsCOR0DMWO49axuxJneAjUaRPDZ0T7MN6iRGCPVnJ6ur0qnqElAcgUysfPIpCK2ow/oYu6Btooc22CVUY3k9VIACbpE9ZNUYqHo=
Message-ID: <2375c9f90703120652w59ca82a5k5e3f4d0ccaee80af@mail.gmail.com>
Date: Mon, 12 Mar 2007 21:52:02 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: davids@webmaster.com, linux-kernel@vger.kernel.org,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: Style Question
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEBCCDAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.61.0703120638030.4339@yvahk01.tjqt.qr>
	 <MDEHLPKNGKAHNMBLJOLKOEBCCDAC.davids@webmaster.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/12, David Schwartz <davids@webmaster.com>:
>
> > NULL has the same bit pattern as the number zero. (I'm not saying the bit
> > pattern is all zeroes. And I am not even sure if NULL ought to
> > have the same
> > pattern as zero.) So C++ could use (void *)0, if it would let itself :p
>
> They don't have to have the same bit pattern. There's no logical reason a
> NULL pointer couldn't have all bits set and the number zero have all bits
> cleared.
>
> Casts are perrmited to change the bit pattern. For example '(float) 7' can
> result in a different bit pattern than '7' and similarly '(void *) 0' can
> result in a different bit pattern from '0'.
>
> As a trivial example, consider an LP64 system. NULL will have the bit
> pattern of 64 zero bits, while '0' will have the bit pattern of 32 zero
> bits.
>
> DS

I agree. C99 standard just says:

6.3.2.3 Pointers

"3  An integer constant expression with the value 0, or such an
expression cast to type void *, is called a null pointer constant. If
a null pointer constant is converted to a pointer type, the resulting
pointer, called a null pointer, is guaranteed to compare unequal to a
pointer to any object or function."
