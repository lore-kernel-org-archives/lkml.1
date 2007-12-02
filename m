Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbXLBG7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbXLBG7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 01:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXLBG7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 01:59:11 -0500
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:23585 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751408AbXLBG7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 01:59:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xTf953fkMc7nDLZoEMwLVZ/901SkGPN2o3D2c8c6sv8ebt7gW5bqS5bvgQKvoiljeGackKLpV41KyLe+Tu8eGVJSxVri3OpKdH3pEQ3ZxOdEepHIK7doFJ36RHKetiNfVZtjRwwv+6CPOXNGssbdcGwIp77fyLpC+FYnuK5axwo=  ;
X-YMail-OSG: kP6RQ1YVM1nQb8if7MbBOudkabw.dv2zOJgnZV4gPv39mcEit5xDabp4aGKgp0WUoYDAncCOPg--
From: David Brownell <david-b@pacbell.net>
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Subject: Re: blackfin compile error
Date: Sat, 1 Dec 2007 22:59:05 -0800
User-Agent: KMail/1.9.6
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Bryan Wu" <bryan.wu@analog.com>, linux-kernel@vger.kernel.org
References: <20071202004204.GE15974@stusta.de> <386072610712012242i58e48aebk17fec7a87391a7fc@mail.gmail.com>
In-Reply-To: <386072610712012242i58e48aebk17fec7a87391a7fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712012259.06493.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 December 2007, Bryan Wu wrote:
> On Dec 2, 2007 8:42 AM, Adrian Bunk <bunk@kernel.org> wrote:
> > It seems commit 5d448dd50712ae42f8176b5bb8db4703bef6f0f5 was incomplete:
> >
> > <--  snip  -->
> >
> > ...
> >   CC      arch/blackfin/mach-bf537/boards/stamp.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: error: unknown field 'pin_req' specified in initializer
> 
> Yes, there is a SPI patch adding the field 'pin_req' in a Blackfin SPI
> header file which is in -mm tree.
> 
> David, could you please submit the Blackfin SPI update to mainline?

So far as I know they're all ready for Andrew to get them to Linus...


> > /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: error: extra brace group at end of initializer
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: error: (near initialization for 'bfin_spi0_info')
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: warning: excess elements in struct initializer
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c:539: warning: (near initialization for 'bfin_spi0_info')
> > make[2]: *** [arch/blackfin/mach-bf537/boards/stamp.o] Error 1
> >
> > <--  snip  -->
> >
> > cu
> > Adrian
> >
> > --
> 
