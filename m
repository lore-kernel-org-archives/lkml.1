Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbZA1Oi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbZA1Oi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZA1OiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 09:38:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:57389 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZA1OiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 09:38:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Go0O7ITXSoSaU9Xq207taPf2i7GDaDZFWEA8M2Z4W+yyhpMSjHvzStp0pVZeTu5s6S
         kF1I2QWIsK1r4LX4r9AXoXuTecwnPBuwA4M1vewSZUGcO0prHuQyub1AJawSiMejPeDf
         c11O/wlKgxEiVsj+pVJqndjokRleaJiwt6Dkg=
MIME-Version: 1.0
In-Reply-To: <20090128102841.GA24924@barrios-desktop>
References: <20090128102841.GA24924@barrios-desktop>
Date: Wed, 28 Jan 2009 23:38:17 +0900
X-Google-Sender-Auth: 3e2c02abfa9ac2a8
Message-ID: <2f11576a0901280638w6a18d5fel4997a226a8e924cc@mail.gmail.com>
Subject: Re: [BUG] mlocked page counter mismatch
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>
Cc: linux mm <linux-mm@kvack.org>, linux kernel <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/28 MinChan Kim <minchan.kim@gmail.com>:
>
> After executing following program, 'cat /proc/meminfo' shows
> following result.
>
> --
> # cat /proc/meminfo
> ..
> Unevictable:           8 kB
> Mlocked:               8 kB
> ..

ok, I'll hand this bug.
