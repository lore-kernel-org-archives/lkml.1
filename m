Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071Ab0CAReb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:34:31 -0500
Received: from mail-bw0-f212.google.com ([209.85.218.212]:54418 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0CARea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:34:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kseEKA+7Wc0elw+IC0PpdBBVLb68A7t3u1yfarUjMGq0oLcIFeih5QuSqAjuvPCb/y
         OhO1Cbwftpagds3Td5m+BhqfTuhws9gBcUZixDmk7K9PeZgMM22nzXP/DvQCipjGeJEz
         6Se5xjSUACnp+T3Jtkml84xEUyHnMjYp/jLjw=
MIME-Version: 1.0
In-Reply-To: <4807377b1002261152x6a92cfffl6ecb09d0574156d4@mail.gmail.com>
References: <2d460de71002260242o50952e51sa9aee59d2b7bbe2e@mail.gmail.com>
	 <4807377b1002261152x6a92cfffl6ecb09d0574156d4@mail.gmail.com>
Date: Mon, 1 Mar 2010 18:34:25 +0100
Message-ID: <2d460de71003010934m76594f4fk2e0b505b1867538c@mail.gmail.com>
Subject: Re: New thread: page allocation failure with E1000 (seems to be 
	reproducible)
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc: e1000-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Andrew Pochinsky <avp@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

> the memory allocation (order:0), while unexpected, are not fatal, and
> the e1000 driver is written to handle the failures during allocation.
>
> Does something else happen to the system after this or does operation continue?

I can not be sure, but I _think_ some bogus data made it into userspace.
I did have some binary in a text string I received & logged, which is a
tad unusual.


> You might be able to try the sysctl tweak to reserve a little more
> memory for driver allocations.
> # sysctl vm.min_free_kbytes
> # sysctl -e vm.min_free_kbytes=<double what you have>

I will try that, thanks.


> have you increased the number of rx/tx descriptors in use by e1000?

No. Should I?



Thanks,
Richard
