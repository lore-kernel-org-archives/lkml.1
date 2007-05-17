Return-Path: <linux-kernel-owner+w=401wt.eu-S1757094AbXEQPfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbXEQPfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 11:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXEQPfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 11:35:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:15299 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbXEQPfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 11:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p27xKhlCN0IY+Fc4BtJjPmWUAnReqnJx/G2Q8unbTPdzQJRjnEpK260U6WXsvnF3zC24dPrJMCidY3yIuG2QMnY39/S0NOz3PxuBYtT9+wEHZUITtB5Ls6iu7Xdst0+4ANae0ImBv+XLExR5Y2eRQB4zMTHPbI/oj99ngiRtIWE=
Message-ID: <d120d5000705170835x2d243b46of31ca186223390af@mail.gmail.com>
Date: Thu, 17 May 2007 11:35:38 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Pavel Emelianov" <xemul@sw.ru>
Subject: Re: [PATCH] Make common helpers for seq_files that work with list_head-s
Cc: "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       axboe@kernel.dk, herbert@gondor.apana.org.au, kkeil@suse.de,
       trond.myklebust@fys.uio.no, chas@cmf.nrl.navy.mil, kaber@trash.net,
       devel@openvz.org
In-Reply-To: <464C728C.8050507@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464C728C.8050507@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On 5/17/07, Pavel Emelianov <xemul@sw.ru> wrote:
> Many places in kernel use seq_file API to iterate over a regular
> list_head. The code for such iteration is identical in all the
> places, so it's worth introducing a common helpers.
>

Makes sense, however I am working on that part of the input code so if
you could split input out so I could apply it later that'd be grand.
Thanks!

-- 
Dmitry
