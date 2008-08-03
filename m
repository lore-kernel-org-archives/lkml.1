Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYHCJVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYHCJVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 05:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYHCJVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 05:21:07 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:12549 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbYHCJVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 05:21:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uivZMyvZTF5b/VUcW5JX8SHFJRkxqlMRA0hH64zGerjVX7nP9blhd1JBLk74lsswIk
         qXwK3asntCZgaGhKDgGC4HxaYt9pkxCMZSI4K1f3ovWZxf4dOzvenWGjHsh7QeKUVDBk
         wWEHH5q9U1IkuioPOZynHlyFgivfTsRd9G//g=
Message-ID: <a4423d670808030221w37653154qd7e2a0bfca6b2e6d@mail.gmail.com>
Date: Sun, 3 Aug 2008 13:21:04 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH] drivers/video/console/promcon.c: fix build error
Cc: tim.bird@am.sony.com, linux-kernel@vger.kernel.org
In-Reply-To: <1217753816.2500.13.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080802230357.GE4856@orion>
	 <1217753816.2500.13.camel@shinybook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/3 David Woodhouse <dwmw2@infradead.org>:
> On Sun, 2008-08-03 at 03:03 +0400, Alexander Beregalov wrote:
>> From: Alexander Beregalov <a.beregalov@gmail.com>
>>
>> drivers/video/console/promcon.c: fix build error
>>
>> drivers/video/console/promcon.c:158: error: implicit declaration of
>> function 'con_protect_unimap'
>>
>> Introduced by commit 4744b43431e8613f920c5cba88346756f53c5165
>
> Commit a29ccf6f823a84d89e1c7aaaf221cf7282022024, surely?
Yes, my mistake.
>
> And in fact it looks like we could remove those parts of promcon.c
> completely if !CONFIG_CONSOLE_TRANSLATIONS. But your patch is certainly
> correct, and I've applied it to my 'random-2.6.git' tree which I've
> already asked Linus to pull.
Thanks.
