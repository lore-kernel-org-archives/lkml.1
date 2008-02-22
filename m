Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbYBVPrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbYBVPrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 10:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbYBVPq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 10:46:59 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:35211 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbYBVPq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 10:46:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XKv9C2mdJU2GBiH3rp9rKLuNqg0tBlQbmO3tVHx3fQhar5NxBABNmUTYjYn9Fs2qJz4GcESvhgGyqRH+5Qqpi/OCZsT0R2jfoR69eheL7jlfrPWWOXdITPas9VH8ZWtVJ0rGCQiKxQWAxkeaEPhcasLB9IvxgQvN0hcMDDGcqO0=
Message-ID: <c6b1100b0802220746s3441d28cj92896618bbb57bde@mail.gmail.com>
Date: Fri, 22 Feb 2008 15:46:54 +0000
From: "Chris Clayton" <chris2553@googlemail.com>
To: ivdoorn@gmail.com
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <200802181911.32128.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	 <200802181911.32128.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivo,

On 18/02/2008, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>

[...]

> Above traces should be enough, but to determine where rt2x00 broke
>  down approximatly I need to have a few test result on specific moments.
>  Could you test the kernel with the following versions:
>
>  rt2x00 2.0.11   2d68de3efa62655d551092f5c787505735d561ad
>  rt2x00 2.0.12   a3c7aa58df7df80aa05f166fe3e42482247164cf
>  rt2x00 2.0.13   5a6012e105ae1664cd2841c33bf59fbdd8d4dbcc
>
>  Checking those out is simply a matter of:
>  git branch 2.0.11 2d68de3efa62655d551092f5c787505735d561ad
>  git checkout 2.0.11
>

OK, we seem to be struggling a little, so I've built an installed git
and cloned Linus' 2.6 tree. My wireless network dies after a few pings
with rt2x00 2.0.11.

>  No further bisecting is needed, but with above tests I can at least
>  narrow it down to find the cause of this issue.
>

If you need me to bisect, just shout. Please be patient though, I'm
exploring new territory here :-)

Thanks

Chris
>  Thanks.
>
>
>  Ivo
>
>


-- 
Beauty is in the eye of the beerholder.
