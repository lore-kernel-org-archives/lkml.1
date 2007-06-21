Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbXFUQu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbXFUQu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbXFUQuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:50:16 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45795 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbXFUQuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:50:14 -0400
Date: Thu, 21 Jun 2007 09:51:39 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: 2.6.22-rc4-mm2: serial-convert-early_uart-to-earlycon-for-8250
In-reply-to: <467A825E.9000708@shadowen.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <467AAC9B.3040905@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <467A825E.9000708@shadowen.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> The following patch to 2.6.22-rc4-mm2 seems to update the early console
> support for the 8250 uarts:
> 
>     serial-convert-early_uart-to-earlycon-for-8250
> 
> This moved from naming the 8250 uart 'uart' to 'uart8250' in the
> console= kernel parameter.  While this is sensible long term to allow
> other uarts to be supported sanely this puts existing users with
> existing console configurations in a difficult position as their console
> output just stops appearing.  It makes life almost impossible for any
> automatic testers as they now need to have different command lines for
> different versions of the kernel.
> 
> I think we need to maintain 'uart' as an alias here.

I will try to make one patch to use uart too.

YH
