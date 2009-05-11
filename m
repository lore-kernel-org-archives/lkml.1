Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbZEKCIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbZEKCIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 22:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbZEKCIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 22:08:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:55533 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZEKCIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 22:08:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=weRW8eanrkCPho4c2frrCXDavrwjCjlLEStKKaEnxm2f+CiEz2cmt1+bLOQC4gwxkQ
         GXXzIrgU31afhuyOKyPvx9o7orV0hw+FHJyxdK8/XRdQWKX85OdWcW3XnCgy+G720ES5
         HZWuAzvwk4mhhBt0O2jTnYOhkbD4rWuGzcRwQ=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kim Kyuwon <q1.kim@samsung.com>
Subject: Re: [PATCH] Input: add MAX7359 key switch controller driver, v2
Date: Sun, 10 May 2009 19:08:36 -0700
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4; KDE/4.2.2; x86_64; ; )
Cc: Trilok Soni <soni.trilok@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
References: <4A04E5EA.7000103@samsung.com> <20090509200118.GB1617@dtor-d630.eng.vmware.com> <4A0784A4.1010703@samsung.com>
In-Reply-To: <4A0784A4.1010703@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905101908.36933.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KIm,

On Sunday 10 May 2009 18:51:32 Kim Kyuwon wrote:
> Hi Dmitry,
>
> Thank you for streamlining this driver. I confirmed this streamlined driver
> is nicely working on my S3C6410 board and of course I mostly like your
> changes.

Great, thanks for testing.

> But I'm afraid this 'error' variable is not used at the final
> return statement in the probe function.

*blush* Hm, apparently I did not quite finish converting it all to use
"error" ;) I personally like calling such variables "error" if they are
"returned" only in error path and "ret" or "retval" when they are
returned upon both error and successful completion of a function.
I will fold your patch into the original version, thanks a lot.

-- 
Dmitry
