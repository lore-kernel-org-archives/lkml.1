Return-Path: <linux-kernel-owner+w=401wt.eu-S1763375AbYFFQkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763375AbYFFQkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbYFFQkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:40:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:63933 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbYFFQkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:40:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=j9miXzyt0XSuapdAz6OzwQyesu4vSQpsymM6WygXsk+TCPEfVH7m3pICnuJmcQFP0t
         EF5X5/gseIi00Kt/06sHjJxZQ3vHz+aj6PxsgswxBxAj1R3YZHAuM+UW4JqNpBsfpWIB
         3jEsVdk+GotheSV3qH4munD34AASUSEZAmgf0=
Message-ID: <386072610806060940r5bea0549va4a0a1ae587777bf@mail.gmail.com>
Date: Sat, 7 Jun 2008 00:40:00 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: serial/bfin_5xx.c build error
Cc: "Graf Yang" <graf.yang@analog.com>, sonic.zhang@analog.com,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20080606162203.GB2201@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080606162203.GB2201@cs181133002.pp.htv.fi>
X-Google-Sender-Auth: 2925514c99b77fa8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 12:22 AM, Adrian Bunk <bunk@kernel.org> wrote:
> Commit 7d01b475ab17018756c8df27c2ee3c220fab05f8
> (Blackfin Serial Driver: Enable IR function when user application)
> causes the following build error:
>
> <--  snip  -->
>
> ...
>  CC      drivers/serial/bfin_5xx.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c: In function 'bfin_serial_init':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c:1209: error: 'struct tty_driver' has no member named 'set_ldisc'
> make[3]: *** [drivers/serial/bfin_5xx.o] Error 1
>
> <--  snip  -->
>
> In case it can't be fixed quickly a revert might be an option for 2.6.26.
>

Graf has already sent me a patch to fix this. After I test it on my
board, I will send it out for Linus git pull.

Thanks a lot
-Bryan
