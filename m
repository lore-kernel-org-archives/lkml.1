Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbZCDLMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbZCDLMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZCDLMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:12:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54445
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750991AbZCDLML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:12:11 -0500
Date: Wed, 04 Mar 2009 03:11:56 -0800 (PST)
Message-Id: <20090304.031156.159121545.davem@davemloft.net>
To: arvidjaar@gmail.com
Cc: brian.haley@hp.com, vladislav.yasevich@hp.com, chuck.lever@oracle.com,
       tytso@mit.edu, Valdis.Kletnieks@vt.edu, rjw@sisk.pl,
       netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       jamagallon@ono.com, linux-kernel@vger.kernel.org, fubar@us.ibm.com
Subject: Re: [PATCH 0/2] Bonding: fix IPv6 module requirement regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <200903040720.34497.arvidjaar@gmail.com>
References: <49ADE956.1020702@hp.com>
	<200903040720.34497.arvidjaar@gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n24BCXwM031768

From: Andrey Borzenkov <arvidjaar@gmail.com>
Date: Wed, 4 Mar 2009 07:20:30 +0300

> On 4 Ğ¼Ğ°Ñ€Ñ‚Ğ° 2009 05:37:10 Brian Haley wrote:
> > These patches fix the Bonding module's requirement to have the IPv6
> > module loaded and configured by creating a new "disable" module
> > parameter value for ipv6.ko.  This allows users who do not want any
> > IPv6 addresses or sockets to be created to disable IPv6 support,
> > while still loading the module and making it's symbols available. 
> > This can be specified in /etc/modprobe.conf (or similar) with
> > "options ipv6 disable=1".
> 
> While this is definitely the right approach, it requires completely new 
> infrastructure to disable IPv6 (including resolving update issues). So I 
> guess this is post-2.6.29 material.

No, Brian's patches are is the only reasonable way to fix this
bug, even in 2.6.29

We not going to let the ipv6 module load disable hack live any
longer, sorry.

I'm going to apply and push out Brian's patches.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
