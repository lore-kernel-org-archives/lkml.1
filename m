Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbXITQ4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbXITQ4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbXITQ4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:56:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:46229 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbXITQ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:56:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pHQhPykiJ0C7irKMogtdUbz9kkcqbJERwwae2q0AAnuIuQJoicoItIfBhysR8gBWfOQQExeyVK3By59nSEd+uIJ4ra8tbEMyBGDIUaaKQfrs2pHmhlYD6nyKZfOf/6KpCWSSDHK5ZbdWloFf/CWhR/mio7v0JvRuiPds2SWt5rY=
Message-ID: <91b13c310709200956n155ff614p7234d28829a9b8ce@mail.gmail.com>
Date: Fri, 21 Sep 2007 00:56:35 +0800
From: "rae l" <crquan@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/3] netlink: the temp variable name max is ambiguous
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, cr_quan@163.com
In-Reply-To: <20070916.163650.88475186.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1188675959178-git-send-email-crquan@gmail.com>
	 <11886759682348-git-send-email-crquan@gmail.com>
	 <20070916.163650.88475186.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/07, David Miller <davem@davemloft.net> wrote:
> From: Denis Cheng <crquan@gmail.com>
> Date: Sun,  2 Sep 2007 03:45:58 +0800
>
> > with the macro max provided by <linux/kernel.h>, so changed its name to a more proper one: limit
> >
> > Signed-off-by: Denis Cheng <crquan@gmail.com>
>
> Not strictly necessary because CPP knows to differentiate between
> 'max(' and plain 'max' when evaluating if a CPP macro should be
> expanded or not.
I also know the GNU CPP is intelligent, but people are often not.
I just think the avoidance to use human ambiguous names could give
more readability.

>
> Nonetheless, applied to net-2.6.24, thanks.
>

-- 
Denis Cheng
