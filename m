Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZDRSTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZDRSTg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 14:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZDRST2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 14:19:28 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:47879 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395AbZDRST1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 14:19:27 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-12.arcor-online.net B65891B39C2
From: Bodo Eggert <7eggert@web.de>
Subject: Re: [PATCH] Wait for console to become available, ver 3.1
To: David VomLehn <dvomlehn@cisco.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Sat, 18 Apr 2009 20:19:24 +0200
References: <cs5Fw-2fr-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LvF8O-0001hV-JE@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David VomLehn <dvomlehn@cisco.com> wrote:

> +     consoledelay=ms [KNL] Wait up to ms milliseconds for the preferred
> +                     console to be registered, then continue. Useful for
> +                     systems where a console may not be plugged in, such as
> +                     for USB serial devices.

> +     consolewait     [KNL] Wait (indefinitely) for preferred console device
> +                     to be registered. Useful, for example, for USB serial
> +                     devices, but will never complete booting if no console
> +                     is plugged in.

I'd use (consoledelay == -1) -> wait forever.

