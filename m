Return-Path: <linux-kernel-owner+w=401wt.eu-S965428AbXA3IQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965428AbXA3IQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 03:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965429AbXA3IQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 03:16:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:64781 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965428AbXA3IQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 03:16:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c4ORRlQ4akclZx9zQmwSHk15jd9vvaKWb1vw/ZVYkOxkiuvohWwc1D0jepPkKackCRgN1zKjarfkZZ9S784Hwx09mscebScZMWQesn4rO95HinMJ5mROJGPYcJ+YvfyZbvajlTh+8QvT0DHc9vB23PRwWk6QiztKDCEghUMpHuM=
Message-ID: <8355959a0701300016k7c835fb3v31b4424edde3741c@mail.gmail.com>
Date: Tue, 30 Jan 2007 13:46:54 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>
Subject: Re: 2.6.20-rc6-mm3
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070129204528.eb8d695e.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070129204528.eb8d695e.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/07, Andrew Morton <akpm@osdl.org> wrote:
>
> - If you hit a bug in -mm and it is not obvious which patch caused it, it is
>   most valuable if you can perform a bisection search to identify which patch
>   introduced the bug.  Instructions for this process are at

I am hit with a compile error! Here is the info:-

  CC [M]  drivers/net/chelsio/cxgb2.o
  CC [M]  drivers/net/chelsio/espi.o
  CC [M]  drivers/net/chelsio/tp.o
  CC [M]  drivers/net/chelsio/pm3393.o
  CC [M]  drivers/net/chelsio/sge.o
drivers/net/chelsio/sge.c: In function 't1_interrupt':
drivers/net/chelsio/sge.c:1705: error: expected ')' before 'work_done'
drivers/net/chelsio/sge.c:1722: error: expected expression before '}' token
drivers/net/chelsio/sge.c:1697: warning: unused variable 'work_done'
drivers/net/chelsio/sge.c:1722: warning: no return statement in
function returning non-void
make[3]: *** [drivers/net/chelsio/sge.o] Error 1
make[2]: *** [drivers/net/chelsio] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2


~Akula2
