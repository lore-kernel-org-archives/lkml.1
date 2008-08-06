Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYHFWUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYHFWUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbYHFWUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:20:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:14030 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbYHFWUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:20:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=X7JqdL8u4Oc1bVe6Wrq6fmc7qWknnhG4dVGfZzLxGE/Xa8A1WVUlprUpFT138eUUau
         sKfdyzfc223wTK0e7Ypy4q7a5VakVTXLf2bevtYtccQQgk5+3RN0uPa157kg6MQ8opG/
         pD/EBuH0FSLzv8WEZRl6xcjwDf79QY8gIIRhs=
Message-ID: <2c0942db0808061520y50dd88fende33b8d9b9d575e5@mail.gmail.com>
Date: Wed, 6 Aug 2008 15:20:10 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "=?UTF-8?Q?Piotr_Jaroszy=C5=84ski?=" <p.jaroszynski@gmail.com>
Subject: Re: HZ from userspace
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2c0942db0808061516r730496d6hbc75eb9c5b49923a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <d77765540808061348u58cfe6a3pa437a9501bb9abff@mail.gmail.com>
	 <2c0942db0808061449s48ba235cy1b5672c0952b8fdf@mail.gmail.com>
	 <d77765540808061507v47561931x23a23c30067bc57b@mail.gmail.com>
	 <2c0942db0808061516r730496d6hbc75eb9c5b49923a@mail.gmail.com>
X-Google-Sender-Auth: c857af0d0bbbffb7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m76MKrIG013923

On Wed, Aug 6, 2008 at 3:16 PM, Ray Lee <ray-lk@madrabbit.org> wrote:> On Wed, Aug 6, 2008 at 3:07 PM, Piotr JaroszyÅ„ski> <p.jaroszynski@gmail.com> wrote:>>>> I want to be able to convert starttime from /proc/#/stat to absolute>>>> time and it seems that I need HZ to do that as it is measured in>>>> jiffies. How can I get HZ? I have seen some discussion about this but>>>> haven't found a definite answer. procps is using some hacks do it and>>>> I would prefer to avoid them.>>>> I only need a solution for modern kernels, say 2.6.20+ if that matters.>>>>>> `man sysconf`, in particular you want sysconf(_SC_CLK_TCK).>>>> manpage says it's obsolete and i read in some discussion that it only>> returns the default and not the real HZ used.>> I believe the claim that it's out of date is out of date. manpages> 3.0.1 has an update to this, according to a message I saw on this list> a month or so ago.>> Regardless, the fields you're reading should all be showing USER_HZ> which is fixed at 100 per second regardless of the underlying kernel> HZ parameter.>> Try it.>
Here's the latest proc(5) man page from June 25, 2008. Look for_SC_CLK_TCK about a third of the way down.
http://www.kernel.org/doc/man-pages/online/pages/man5/proc.5.htmlÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
