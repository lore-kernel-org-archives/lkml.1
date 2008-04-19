Return-Path: <linux-kernel-owner+w=401wt.eu-S1761953AbYDSDRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761953AbYDSDRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 23:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144AbYDSDRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 23:17:39 -0400
Received: from rv-out-0708.google.com ([209.85.198.246]:26400 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757331AbYDSDRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 23:17:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jZvnQrnCFvwI50+PI/uK1IbnUpQMv1IkMhHs5FE3qy47jAMEQO1PWcZ0JuTFo1fE28DAkQyIUJd+PRC5kMPzG4VhG7TAtfWyZQIH31kxm9QjfislE5IaVZNFfscC/SHhH74+L9UoYTYjahIAxWQgLtoLB+Lqd5xjdmFM4PLkUw4=
Message-ID: <86802c440804182017r4fe78371w3a4a714a44591223@mail.gmail.com>
Date: Fri, 18 Apr 2008 20:17:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: [PATCH] x86_64: simplify the memtest parameter setting
Cc: "Yinghai Lu" <yhlu.kernel.send@gmail.com>, mingo@elte.hu,
       akpm@linux-foundation.org, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <200804190415.47552.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181749.15782.yhlu.kernel@gmail.com>
	 <200804190357.09243.elendil@planet.nl>
	 <200804190415.47552.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 7:15 PM, Frans Pop <elendil@planet.nl> wrote:
> On Saturday 19 April 2008, Frans Pop wrote:
>  > Yinghai Lu wrote:
>  > > -config MEMTEST_BOOTPARAM
>  > > -   bool "Memtest boot parameter"
>  > > +config MEMTEST
>  > > +   bool "Memtest"
>  > >  depends on X86_64
>  > >  default y
>  >
>  > With this patch, this default no longer makes any sense.
>  >
>  > >  help
>  > >  This option adds a kernel parameter 'memtest', which allows memtest
>  > > -     to be disabled at boot.  If this option is selected, memtest
>  > > -     functionality can be disabled with memtest=0 on the kernel
>  > > -     command line.  The purpose of this option is to allow a single
>  > > -     kernel image to be distributed with memtest built in, but not
>  > > -     necessarily enabled.
>  > > -
>  > > +     to be set.
>  > > +           memtest=0, mean disabled; -- default
>  > > +           memtest=1, mean do 1 test pattern;
>  > > +           ...
>  > > +           memtest=4, mean do 4 test patterns.
>  >
>  > s/mean/means/
>  > s/; -- default/ (default)/
>
>  These are still good (IMO).
>
>
>  > Maybe some explanation of what a "test pattern" is would be useful.
>  >
>  > >  If you are unsure how to answer this question, answer Y.
>  >
>  > Also makes no sense anymore.
>
>  Oops. Just see I was too fast. After reading it again I see that the y/n
>  value is correct after all.
>
>  However, it also means that the new description is probably too short.
>  The phrase "allows memtest to be set" does not really mean anything to a
>  user who does not know what memtest really does. It also does not explain
>  that memtest is a boot parameter.
>
>  Also, it should probably be made more explicit that no memtest is actually
>  performed unless the memtest boot parameter is passed at the boot prompt.
>
>  Looks like 4 is the maximum possible value. This should be mentioned
>  explicitly (here as well as in Documentation/kernel-parameters.txt).

current it only support 4 pattern, will try to move memtester pattern
into it later...

YH
