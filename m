Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbXEEXhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbXEEXhG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 19:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbXEEXhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 19:37:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:31074 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbXEEXhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 19:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nrKtPgJ4eYQCUVwJiEh30EaUYQAv+SrfcNcBv/90UHBgkclLuhcJG8WgtXfdheZFeheF9Ua5ZeVho42tNMP8wlhrgQjxQTHnJYlinIcRShxRqBNQU0SEjNOL1Sv7Mis6TiOzbM5KqVpWgCfgivOgsVbDs+eHpOjmnc90F54pMAg=
Message-ID: <6bffcb0e0705051637k6e39bcds76456ea5ff5f11c5@mail.gmail.com>
Date: Sun, 6 May 2007 01:37:02 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Srihari Vijayaraghavan" <sriharivijayaraghavan@yahoo.com.au>
Subject: Re: [PROBLEM] 2.6.21-git oops
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4968.12298.qm@web52606.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4968.12298.qm@web52606.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srihari,

On 06/05/07, Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au> wrote:
> [Sorry to reply to my own email, but I had some good development on this
> problem]
>
> --- Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au> wrote:
> > Here's the first one (there a couple following this;
> > the complete dmesg is at the bottom of this email):
>
> It turns out the system is no go with 4 GB of RAM (4 * 1 GB modules): system
> instability & SATA controller doesn't detect the drives (as I reported to
> linux-ide:
> http://www.mail-archive.com/linux-ide@vger.kernel.org/msg06174.html).
>
> With only 2 GB of RAM (with either pairs), system is very stable (surviving
> many parallel kernel compiles for over 3 times longer than that of 4 GB), and
> it detects & works fine with the SATA drives also.
>
> Any advice on getting all of 4 GB to work reliably with SATA also?
>
> Thanks
>
> PS: Here's a dmesg of the all stably working 2 GB system, & the oopsy one with
> 4 GB.
>

This looks like a bad RAM problem too me. Check the RAM memory
http://www.memtest.org/

(Removed from the list of known regressions
http://kernelnewbies.org/known_regressions)

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
