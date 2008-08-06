Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbYHFWH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbYHFWH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYHFWHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:07:48 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:6108 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbYHFWHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:07:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kfZ0l1x3xJyGD76KDHahorDIIcPKeKGZ86jxT1UEh4JUCkgh1xT/FKuiB4bCV3zhpf
         EpPxRGBzqDm15DpfW0Kcf/ayRvVu8IlCd2+meWLCm7XnWjkWxvOpxAT+jPqMBFrnbag6
         Aqg+sbvF1MPeYJmdyU/+MezqgveyiN0QPOIlE=
Message-ID: <d77765540808061507v47561931x23a23c30067bc57b@mail.gmail.com>
Date: Wed, 6 Aug 2008 22:07:46 +0000
From: "=?UTF-8?Q?Piotr_Jaroszy=C5=84ski?=" <p.jaroszynski@gmail.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: HZ from userspace
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2c0942db0808061449s48ba235cy1b5672c0952b8fdf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <d77765540808061348u58cfe6a3pa437a9501bb9abff@mail.gmail.com>
	 <2c0942db0808061449s48ba235cy1b5672c0952b8fdf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m76M80IG013851

>> I want to be able to convert starttime from /proc/#/stat to absolute>> time and it seems that I need HZ to do that as it is measured in>> jiffies. How can I get HZ? I have seen some discussion about this but>> haven't found a definite answer. procps is using some hacks do it and>> I would prefer to avoid them.>> I only need a solution for modern kernels, say 2.6.20+ if that matters.>> `man sysconf`, in particular you want sysconf(_SC_CLK_TCK).
manpage says it's obsolete and i read in some discussion that it onlyreturns the default and not the real HZ used.
-- Best Regards,Piotr JaroszyÅ„skiÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
