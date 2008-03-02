Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbYCBQAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbYCBQAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 11:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbYCBQAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 11:00:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:1416 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbYCBQAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 11:00:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ve10VwkOoFA1ynOCyBF2MkhGBi4YFe813LR54McnWQ0WB0/3/O7t8FQpHlPyDUbWw7uPS1BnH2chGRApox/NG1g7aj5yLfEhTh/lWjvyeJxd0+rbRvYneFLrnWTLc8jor7FhVUgAzJJlbfXmf3FuYMt8CQsytyvZkPVDxlI8CLU=
Message-ID: <3d8471ca0803020800m6ef56c7enc5e9b28852266c9f@mail.gmail.com>
Date: Sun, 2 Mar 2008 17:00:35 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Pawel Plociennik" <paplociennik@gmail.com>
Subject: Re: [PATCH] chroot= as a new kernel parameter
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200803011409.59526.paplociennik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803011409.59526.paplociennik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 1, 2008 at 8:09 PM, Pawel Plociennik <paplociennik@gmail.com> wrote:
>  In the short this patch has added a new chroot= kernel parameter which can be used
>  to changing a chroot of an init process before it will has been runed.

Wouldn't booting with 'init=/usr/sbin/chroot /path /sbin/init' achieve
the same effect?
Haven't tested it, just wondering.

>  +       if(chroot_str) {
>  +               if(sys_chroot(chroot_str) < 0)
>  +                       printk("chroot=%s failed\n", chroot_str);
>  +               else
>  +                       printk("chroot=%s successed\n",chroot_str);
>  +       }

Continuing booting normally when the chroot failed sounds like a
security issue to me.

Regards.

-- 
Guillaume
