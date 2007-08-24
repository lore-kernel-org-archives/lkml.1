Return-Path: <linux-kernel-owner+w=401wt.eu-S1762739AbXHXR53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762739AbXHXR53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758733AbXHXR5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:57:22 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:1588 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbXHXR5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:57:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d99Ot4Js9JT0YNXgsbtuSUS2OcsvxhW3N2IfowKgj+VMVKVg1kgzzvldalvWH2RyOoBv4/PqXzsMxgS8etE07W3q6lbt9SqGIR8L70mGkT67T/rQpcBOXBouy3uu+/88ZHAewh+25bQRVOcskeBP+uUVJFl267DQ9G2+yFoKm3A=
Message-ID: <40f323d00708241057k6549f22fl6abf802f14c03e44@mail.gmail.com>
Date: Fri, 24 Aug 2007 19:57:20 +0200
From: "Benoit Boissinot" <bboissin@gmail.com>
To: "Udo van den Heuvel" <udovdh@xs4all.nl>
Subject: Re: possible BUG while doing gpg --gen-key
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46CF079C.7010304@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46CF079C.7010304@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/07, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
> While doing gpg --gen-key I can reproduce quite well some sort of
> crash/bug/etc:
> # gpg --gen-key

[snip]

> We need to generate a lot of random bytes. It is a good idea to perform
> some other action (type on the keyboard, move the mouse, utilize the
> disks) during the prime generation; this gives the random number
> generator a better chance to gain enough entropy.
>
[snip]
> Segmentation fault
> (...)
> Call Trace:
>  [<c0103b75>] show_trace_log_lvl+0x1a/0x2f
>  [<c0103c27>] show_stack_log_lvl+0x9d/0xa5
>  [<c0103dfc>] show_registers+0x1cd/0x2e3
>  [<c0104010>] die+0xfe/0x200
>  [<c010fb77>] do_page_fault+0x43c/0x511
>  [<c030220a>] error_code+0x6a/0x70

iirg gpg-keygen uses a lot of cpu time during that phase, you probably
should verify your ram and cpu. This kind of problem is often due to
faulty hardware.

regards,

Benoit
