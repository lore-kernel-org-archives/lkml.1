Return-Path: <linux-kernel-owner+w=401wt.eu-S1753433AbXLaSkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753433AbXLaSkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbXLaSke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:40:34 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:33754 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751754AbXLaSkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:40:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KnEXg9gKl2AMJDCeCdNeBPHSONhNxVFfMV6k7UPL/rj1oXpeFXoQvYBZC9wK+lEA4kD/GtCuA/hT7cRbvISgd41wNiygubi9UA7gIqghWhGHcT76sc/Ld4JOnCiY/pEv+KdsNigVJR3Sf4P60r/WGsw8EtCda+G+2FL3VaMNiio=  ;
X-YMail-OSG: 7QETlE4VM1m9fbp5EUsUOa1vIpS4_Fi1NpNoiSDUYCDnRNA7ksoD9HIYQG7ei5NJEzhYzn6zDw--
From: David Brownell <david-b@pacbell.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.24-rc6-mm1 (build problem: gpio_keys)
Date: Mon, 31 Dec 2007 10:40:27 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071231101837.65640746.randy.dunlap@oracle.com>
In-Reply-To: <20071231101837.65640746.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712311040.28190.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 December 2007, Randy Dunlap wrote:
>   CC      drivers/input/keyboard/gpio_keys.o
> In file included from /local/linsrc/linux-2.6.24-rc6-mm1/drivers/input/keyboard/gpio_keys.c:27:
> include2/asm/gpio.h:4:18: error: gpio.h: No such file or directory

Find whatever broken patch selected (on x86_64)

   CONFIG_GENERIC_GPIO=y

without actually providing that support (by providing <asm/gpio.h> and
an implementation backing it up).  That's the patch which broke those
various GPIO-dependant drivers.

- Dave


