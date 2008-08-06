Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYHFVuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYHFVuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYHFVtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:49:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:11847 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYHFVtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:49:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ibmpT9Z1IxiynU+AgPz1eTNUgYewAfYOeSlqCct+a2SvZUMqqZnEZT2Xzc8eK3JqkX
         aPOEKYJgTPFKVpeRFsQD/B/OLiLlYFnFp55NDvkciDc60SGr/+Wnqr3Vx7tiWp3K5fXX
         1Ma7Oa0wyqAyg5duWidrRC4B6kQ/TRvzxULWU=
Message-ID: <2c0942db0808061449s48ba235cy1b5672c0952b8fdf@mail.gmail.com>
Date: Wed, 6 Aug 2008 14:49:49 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "=?UTF-8?Q?Piotr_Jaroszy=C5=84ski?=" <p.jaroszynski@gmail.com>
Subject: Re: HZ from userspace
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <d77765540808061348u58cfe6a3pa437a9501bb9abff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <d77765540808061348u58cfe6a3pa437a9501bb9abff@mail.gmail.com>
X-Google-Sender-Auth: 2502ee38ee70e240
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m76Lo6IG013754

On Wed, Aug 6, 2008 at 1:48 PM, Piotr JaroszyÅ„ski<p.jaroszynski@gmail.com> wrote:> Hello,>> I want to be able to convert starttime from /proc/#/stat to absolute> time and it seems that I need HZ to do that as it is measured in> jiffies. How can I get HZ? I have seen some discussion about this but> haven't found a definite answer. procps is using some hacks do it and> I would prefer to avoid them.> I only need a solution for modern kernels, say 2.6.20+ if that matters.
`man sysconf`, in particular you want sysconf(_SC_CLK_TCK).ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
