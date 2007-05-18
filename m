Return-Path: <linux-kernel-owner+w=401wt.eu-S1763299AbXERWUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763299AbXERWUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 18:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbXERWT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 18:19:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:24368 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbXERWT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 18:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=Fcy5gikx28yrqPPeKXjC8OSiuQkLieZdMxaTU302TCeHmSPwTIRNeBQIIb/hsdpbaA9ijlrpEc/BdEjnMrelhjsWF65nTkmeChIVFxOlp+HRofI59rYk+8pmCs8iOH3h2HF67BnfzEL/kuEKToWESONUKMcP3SPAfvFHtXyGy6g=
Organization: Organization? Not detectable
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git patches] net driver updates
Date: Fri, 18 May 2007 18:19:50 -0400
User-Agent: KMail/1.9.6
Cc: Mariusz Koz__owski <m.kozlowski@tuxland.pl>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20070508063337.GA12474@havoc.gtf.org> <200705182346.21835.m.kozlowski@tuxland.pl> <20070518145425.369cb9ff.akpm@linux-foundation.org>
In-Reply-To: <20070518145425.369cb9ff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705181819.50614.gene.heskett@verizon.net>
From: Gene Heskett <gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 May 2007, Andrew Morton wrote:
>On Fri, 18 May 2007 23:46:21 +0200
>
>Mariusz Koz__owski <m.kozlowski@tuxland.pl> wrote:
>> Hello,
>>
>> > diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
>> > index 7053026..111f23d 100644
>> > --- a/drivers/net/smc91x.h
>> > +++ b/drivers/net/smc91x.h
>> > @@ -279,6 +279,40 @@ SMC_outw(u16 val, void __iomem *ioaddr, int reg)
>>
>> ...
>>
>> > +#define SMC_outb(v, a, r) __ __
>> > __outw(((inw((a)+((r)&~1))*(0xff<<8*(r%2)))) | ((v)<<(8*(r&2)))), (a) +
>> > ((r)&~1))
>>
>> This one has unbalanced parenthesis.
>
>I dunno how you can tell - I can't count that high.
>
Try removing the one in front of the comma, it makes the count -1.  And I 
wrote, probably a good 20 years ago, a gizmo I called cntx that found that 
stuff for you.  I occasionally use it to run over a section of the kernel 
tree, but it rarely finds anything to fuss about.  And I really do need to 
make it handle shell expansions so you don't have write a quick script to 
have it scan everything in a directory.  However I suspect that most of you 
already have such a tool in your bag of tricks.

>Can this be programmed in C, rather than in cpp?
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I'm definitely not in Omaha!
