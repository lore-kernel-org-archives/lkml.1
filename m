Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab0AOJtM (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296Ab0AOJtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:49:11 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:64634 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab0AOJtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:49:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QjU1GzewXBUoAtkxnmuiawzdLfWQEsq4v8/XfNyaHf5x4QkO91kwQCihGR7QINCBMw
         DHQDzEFhw3/XV3LsGgd4c+dnzAWIHDzAQMXcqc79u0JiMpGI8p5pFzYdbZzXww5M05wF
         5N89wZRegwm71C+YhwusUZZJRBxJyBO+qw5CE=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1001151039080.23543@ask.diku.dk>
References: <4B502C6B.7000802@s5r6.in-berlin.de>
	 <20100115.005445.263291449.davem@davemloft.net>
	 <tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de>
	 <20100115.012233.202457727.davem@davemloft.net>
	 <Pine.LNX.4.64.1001151039080.23543@ask.diku.dk>
Date: Fri, 15 Jan 2010 11:49:08 +0200
X-Google-Sender-Auth: 425957ab01f5f90a
Message-ID: <84144f021001150149u3b784d26g1822be6c5c3ecbf@mail.gmail.com>
Subject: Re: Changelog quality
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Julia Lawall <julia@diku.dk>
Cc: David Miller <davem@davemloft.net>, stefanr@s5r6.in-berlin.de,
        adi@hexapodia.org, nm127@freemail.hu, david.vrabel@csr.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, cocci@diku.dk,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Fri, Jan 15, 2010 at 11:43 AM, Julia Lawall <julia@diku.dk> wrote:
>> If you want more clear markers around the script so you can skim
>> past it more efficiently when reading the commit message, then ask
>> for that.
>
> If there were markers that would cause tools to hide some information
> under a +, that would be great.  Sometimes I have simplified a script
> beyond what would really be reusable just to not create an over-large
> changelog.  I hope that the simplified version is at least understandable,
> so that the reader can get an idea of what considerations went into the
> change, but I recall in one case having messed up on that as well, and
> ended up with something that really gave no information whatsoever.

It seems to me that the scripts are kernel specific so why don't we
put those useful scripts _within_ the kernel source tree and introduce
a "make coccinelle-check" target?

                        Pekka
