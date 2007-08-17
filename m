Return-Path: <linux-kernel-owner+w=401wt.eu-S1761707AbXHQSnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761707AbXHQSnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 14:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756996AbXHQSn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 14:43:26 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:28673 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229AbXHQSnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 14:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EenmkTlWdJifT3fuT2hb/t4FYGL0HqqSI4VibRKAVfSyY7pflE0wdEODR54szOf+4xiLaTTcYDskqxWuyW4zwxyGayajuQWuojQ8NrNtPrebAaEQyypa6UaZve691botj0vrK632hglaIkWXHiwpKjFBIocbSQ5LDNTbRFLIOs0=
Message-ID: <8bd0f97a0708171143r6b44e506u1c07d8b69e774dd7@mail.gmail.com>
Date: Fri, 17 Aug 2007 14:43:24 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: [draft] Blackfin Early Printk implmentation
Cc: linux-kernel@vger.kernel.org, "Gerd Hoffmann" <kraxel@redhat.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Bryan Wu" <bryan.wu@analog.com>,
       "Sonic Zhang" <sonic.adi@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200708171425.51433.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708152234.06734.rgetz@blackfin.uclinux.org>
	 <200708171336.40159.rgetz@blackfin.uclinux.org>
	 <8bd0f97a0708171057w52e3cd6ekf66a61e8292d3222@mail.gmail.com>
	 <200708171425.51433.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/17/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> On Fri 17 Aug 2007 13:57, Mike Frysinger pondered:
> > On 8/17/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > > +int __init disable_early_printk(void)
> > > +{
> > > +       if (!early_console_initialized)
> > > +               return 0;
> > > +
> > > +       printk(KERN_INFO "Unregister %s%d\n",
> early_console_initialized->name,
> > > +               early_console_initialized->index);
> > > +       unregister_console(early_console_initialized);
> > > +       early_console_initialized = NULL;
> > > +       return 0;
> > > +}
> > > +
> > > +late_initcall(disable_early_printk);
> >
> > i think we agreed this would be OK/good to have in common code
>
> I didn't hear back from Gerd - and in the past this was implemented in the
> arch/*/kernel/early_printk.c - so this is where I put it....

i think his response was "if you do it and he likes the code he'll say yes" :)
-mike
