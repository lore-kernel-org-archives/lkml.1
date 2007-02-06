Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbXBFOtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbXBFOtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 09:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbXBFOtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 09:49:50 -0500
Received: from rtr.ca ([64.26.128.89]:1530 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbXBFOtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 09:49:49 -0500
Message-ID: <45C8958B.8040906@rtr.ca>
Date: Tue, 06 Feb 2007 09:49:47 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Oleg Verych <olecom@flower.upol.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       William Stearns <wstearns@pobox.com>,
       Martin Schlemmer <azarah@nosferatu.za.org>
Subject: Re: [patch 1/3, resend] scripts: replace gawk, head, bc with shell,
 update
References: <20070206011819.160359000@flower.upol.cz> <20070206012207.805083000@flower.upol.cz>
In-Reply-To: <20070206012207.805083000@flower.upol.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Verych wrote:
> scripts: replace gawk, head, bc with shell, update
> 
>   Replacing overhead of using some (external) programs
>   instead of good old `sh'.
...
> -    t4=`echo $t3 | gawk '{ print $1 }'`
> -    t5=`echo $t1 | gawk '{ print $1 }'`
> -    t6=`echo $t4 - $t5 | tr a-f A-F`
> -    t7=`( echo  ibase=16 ; echo $t6 ) | bc`
> +    t4=`field 1 $t3`
> +    t5=`field 1 $t1`
> +    t6=`printf "%lu" $((0x$t4 - 0x$t5))`
...

>From where do we obtain this new "field" command ?

Cheers
