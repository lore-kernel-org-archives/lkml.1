Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbZLBIG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbZLBIG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZLBIG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:06:57 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53126 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZLBIG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:06:57 -0500
Message-ID: <4B162026.2050904@cs.helsinki.fi>
Date: Wed, 02 Dec 2009 10:07:02 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
CC: linux-kernel@vger.kernel.org, catalin.marinas@arm.com
Subject: Re: [PATCH 0/2] fix for kmemleak_erase() (Re: Q, slab, kmemleak_erase()
 and redzone?)
References: <1259740550-10394-1-git-send-email-hooanon05@yahoo.co.jp>
In-Reply-To: <1259740550-10394-1-git-send-email-hooanon05@yahoo.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. R. Okajima kirjoitti:
> Pekka Enberg:
>> No, you are absolutely correct. Can you please send an updated patch to 
>> Catalin that adds a comment on top of the cpu_cache_get() call that 
>> explains why we need it there?
> 
> J. R. Okajima (2):
>   slab, kmemleak, minor, stop calling kmemleak_erase() unconditionally
>   slab, kmemleak, bugfix, pass the correct pointer to kmemleak_erase()
> 
>  mm/slab.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)

Looks good to me. I'll pick these up in slab.git. Thanks!

