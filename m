Return-Path: <linux-kernel-owner+w=401wt.eu-S1751929AbZHKMQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbZHKMQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbZHKMQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:16:47 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:44729 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZHKMQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:16:46 -0400
From: Jack Morgenstein <jackm@dev.mellanox.co.il>
Organization: Mellanox
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [ofa-general] Re: [PATCH 10/14] infiniband: use printk_once
Date: Tue, 11 Aug 2009 10:17:21 +0300
User-Agent: KMail/1.9.1
Cc: general@lists.openfabrics.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com> <200908100936.26963.jackm@dev.mellanox.co.il> <ada7hxba7lx.fsf@cisco.com>
In-Reply-To: <ada7hxba7lx.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908111017.22153.jackm@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009 20:42, Roland Dreier wrote:
> 
>  > I'm a bit nervous about this one.  
>  > printk_once will print once ONLY if CONFIG_PRINTK is set in include/linux/autoconf.h
>  > (i.e., when the kernel is configured).  Otherwise, it gets defined to printk --
>  > and it will always print in this case.
>  > (see 2.6.30.xx kernel include file "include/linux/kernel.h", lines 235, 249, and 272).
> 
> Umm... if CONFIG_PRINTK is turned off nothing prints, right?
Jiri Slaby pointed that out to me -- i.e., that printk itself is defined to do nothing but
return 0 if CONFIG_PRINTK is not defined. (I missed that when looking at file kernel.h).

I thought no answer was needed (sorry about that) -- Jiri was so obviously correct.

I've got no problem with the patch.

-Jack
