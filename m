Return-Path: <linux-kernel-owner+w=401wt.eu-S933707AbYB2XW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707AbYB2XW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 18:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758796AbYB2XWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 18:22:50 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:5617 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326AbYB2XWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 18:22:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kgydIRYuphIBsWuQlmg4V32EMB1yWVuTjd3/vkVamAwjPAOo5mXNwqSDHbNl/lhvw9D/vFofMZgG9Lj2fN7ijCnl0dhbHIwEGrFT2k85pvkVZjQWIFk1T50A47tnwJBTtaoV2Y5Xp7hXfVj6B1tIWwNO45kz+yHltYI090QV9kY=
Message-ID: <f19298770802291522t26055258t363337b74b4969cb@mail.gmail.com>
Date: Sat, 1 Mar 2008 02:22:47 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Michael Buesch" <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Alexey Zaytsev" <zaytsev.a@protei.ru>,
       "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200802290012.56654.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <200802282303.42676.mb@bu3sch.de>
	 <f19298770802281448k91e71dh6583db94e1a6f4e7@mail.gmail.com>
	 <200802290012.56654.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 2:12 AM, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
[...]
>  >
>  > Btw, when booting the system with the b43 driver, I get a
>  > ~30 socond delay after the boot scripts report
>  > "Waiting for /dev to be fully populated" and all the modules
>  > get loaded. Is this something expected?
>
>  That is most likely udev related, which doesn't really like module names
>  and default interface names changing for a known MAC address, depending on
>  your distribution (the following example assumes debian sid, udev 0.114-2)
>  you might have something like /etc/udev/rules.d/z25_persistent-net.rules
>  (which lists MAC addresses and the associated persistent interface name),
>  removing the corresponding stanza for your Broadcom wireless card (or
>  removing the whole file alltogether and letting udev (or rather
>  z45_persistent-net-generator.rules) recreate it during the next boot will
>  most likely fix it.
>
>  This issue is in no way b43 related, it happens with "every" networking
>  devices with changing module names (at least for every legacy wireless
>  module being replaced by a new mac80211 based driver).

Removing the file helped. Thanks.

>
>  Regards
>         Stefan Lippers-Hollmann
>
