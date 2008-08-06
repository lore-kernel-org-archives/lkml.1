Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbYHFWRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbYHFWRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbYHFWQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:16:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:13769 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbYHFWQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:16:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=QoBs9G/wec0ksfi96pTllBxoRdmIE8mRYRv8W4TDhFgz0enfbBWajdfsort43qXrII
         YvZBeOHVDxGDbeuZBoJcTqtf5vWZgMXqbmX7mahrLxl8AnJVHPBUp70kOn7gGacExMY/
         UE5LSynAwbmBya+6s309xKk3HeQ+qr4TeTQrs=
Message-ID: <2c0942db0808061516r730496d6hbc75eb9c5b49923a@mail.gmail.com>
Date: Wed, 6 Aug 2008 15:16:37 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "=?UTF-8?Q?Piotr_Jaroszy=C5=84ski?=" <p.jaroszynski@gmail.com>
Subject: Re: HZ from userspace
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <d77765540808061507v47561931x23a23c30067bc57b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <d77765540808061348u58cfe6a3pa437a9501bb9abff@mail.gmail.com>
	 <2c0942db0808061449s48ba235cy1b5672c0952b8fdf@mail.gmail.com>
	 <d77765540808061507v47561931x23a23c30067bc57b@mail.gmail.com>
X-Google-Sender-Auth: e0c2b2eda48b1116
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m76MHPIG013899

On Wed, Aug 6, 2008 at 3:07 PM, Piotr JaroszyÅ„ski<p.jaroszynski@gmail.com> wrote:>>> I want to be able to convert starttime from /proc/#/stat to absolute>>> time and it seems that I need HZ to do that as it is measured in>>> jiffies. How can I get HZ? I have seen some discussion about this but>>> haven't found a definite answer. procps is using some hacks do it and>>> I would prefer to avoid them.>>> I only need a solution for modern kernels, say 2.6.20+ if that matters.>>>> `man sysconf`, in particular you want sysconf(_SC_CLK_TCK).>> manpage says it's obsolete and i read in some discussion that it only> returns the default and not the real HZ used.
I believe the claim that it's out of date is out of date. manpages3.0.1 has an update to this, according to a message I saw on this lista month or so ago.
Regardless, the fields you're reading should all be showing USER_HZwhich is fixed at 100 per second regardless of the underlying kernelHZ parameter.
Try it.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
