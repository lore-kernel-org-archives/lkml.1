Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbYHBXk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbYHBXk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 19:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYHBXkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 19:40:15 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:20800 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYHBXkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 19:40:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DoGgF1eioH3BOAL8JELgzylXPmQ5BCFrgmtgP8PN3lrmT8SoNQqyNT1rTryCmb4dO8
         RSifHcz7YANxvcLDZ51N3w/1qGI8pHbVhm4/IekxcOIjpQtF7yRqTFF2o5jVE70GC7a/
         EMnZaB78ShTpS9LfwCU68C/T1ufFQL6ZtCn90=
Message-ID: <a4423d670808021640he3ec660k1b5ddfcb6efd1ae5@mail.gmail.com>
Date: Sun, 3 Aug 2008 03:40:12 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] drivers/mtd/mtdsuper.c: fix build error
Cc: viro@zeniv.linux.org.uk, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080802233240.GA4385@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080802225304.GD4856@orion>
	 <20080802233240.GA4385@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/3 Adrian Bunk <bunk@kernel.org>:
> On Sun, Aug 03, 2008 at 02:53:04AM +0400, Alexander Beregalov wrote:
>> From: Alexander Beregalov <a.beregalov@gmail.com>
>>
>> drivers/mtd/mtdsuper.c: fix build error
>>
>> drivers/mtd/mtdsuper.c:184: error: implicit declaration of
>>       function 'lookup_bdev'
>> drivers/mtd/mtdsuper.c:197: error: implicit declaration of
>>       function 'bdput'
>
>
> It already gets fs.h indirectly through linux/mtd/super.h, so while
> your patch might be correct it cannot fix a compile error.
>
> If that's with CONFIG_BLOCK=n then it's
>  http://bugzilla.kernel.org/show_bug.cgi?id=11225
>
> Otherwise please send your .config .

I do not have this config, I collect log from builds with randconfig
and try to fix problems.
It seems it is the same bug.
