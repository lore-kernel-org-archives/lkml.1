Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbYBFXAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbYBFXAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbYBFXAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:00:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:11350 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090AbYBFXAV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:00:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YbwWXvJu7I8T4GM28SSzGUA6mT+lsNG1vDZZG+b3OaKp3W+YJiXxa/7jVp12Sq0G8K+2wxYsAqsYTsLhzOTmZLNTZSiKzpgyv/HqqoEmWj1+aj3caMf4vJicyHfSZCuuGw6xxE+RUpy8zQlaFvncrJKGZMeSnP07WW4uDqKVFL8=
Message-ID: <6101e8c40802061500r5de80eaam3deeb602b9495c7e@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:00:15 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: [2.6.22.y] {02/17} - invalid-semicolon - series for stable kernel #2
In-Reply-To: <6101e8c40802011733ua1bf863v86316585332ef8f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40802011733ua1bf863v86316585332ef8f1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---8<---
From: Ilpo JÃ¤rvinen <ilpo.jarvinen@helsinki.fi>
Subject: [POWERPC] Fix invalid semicolon after if statement
Patch-mainline: 2.6.23-rc4 2b02d13996fe28478e45605de9bd8bdca25718de
Acked-by: schwab@suse.de

    A similar fix to netfilter from Eric Dumazet inspired me to
    look around a bit by using some grep/sed stuff as looking for
    this kind of bugs seemed easy to automate.  This is one of them
    I found where it looks like this semicolon is not valid.

    Signed-off-by: Ilpo JÃ¤rvinen <ilpo.jarvinen@helsinki.fi>
    Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

---
 arch/powerpc/mm/hash_utils_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/hash_utils_64.c	2007-07-08 19:32:17.000000000 -0400
+++ b/arch/powerpc/mm/hash_utils_64.c	2007-08-27 14:01:20.000000000 -0400
@@ -795,7 +795,7 @@ void hash_preload(struct mm_struct *mm,

 #ifdef CONFIG_PPC_MM_SLICES
 	/* We only prefault standard pages for now */
-	if (unlikely(get_slice_psize(mm, ea) != mm->context.user_psize));
+	if (unlikely(get_slice_psize(mm, ea) != mm->context.user_psize))
 		return;
 #endif
---8<---

On 2/2/08, Oliver Pinter (Pintér Olivér) <oliver.pntr@gmail.com> wrote:
> mainline: 2b02d13996fe28478e45605de9bd8bdca25718de
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
