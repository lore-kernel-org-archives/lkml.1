Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbXHQS0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbXHQS0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 14:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760083AbXHQSZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 14:25:55 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:9754 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759534AbXHQSZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 14:25:54 -0400
X-IronPort-AV: i="4.19,276,1183348800"; 
   d="scan'208"; a="37361065:sNHT28031045"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [draft] Blackfin Early Printk implmentation
Date: Fri, 17 Aug 2007 14:25:51 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Gerd Hoffmann" <kraxel@redhat.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Bryan Wu" <bryan.wu@analog.com>,
       "Sonic Zhang" <sonic.adi@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <200708152234.06734.rgetz@blackfin.uclinux.org> <200708171336.40159.rgetz@blackfin.uclinux.org> <8bd0f97a0708171057w52e3cd6ekf66a61e8292d3222@mail.gmail.com>
In-Reply-To: <8bd0f97a0708171057w52e3cd6ekf66a61e8292d3222@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171425.51433.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 17 Aug 2007 18:25:50.0730 (UTC) FILETIME=[09FCEEA0:01C7E0FC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 17 Aug 2007 13:57, Mike Frysinger pondered:
> On 8/17/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > +int __init disable_early_printk(void)
> > +{
> > +       if (!early_console_initialized)
> > +               return 0;
> > +
> > +       printk(KERN_INFO "Unregister %s%d\n", 
early_console_initialized->name,
> > +               early_console_initialized->index);
> > +       unregister_console(early_console_initialized);
> > +       early_console_initialized = NULL;
> > +       return 0;
> > +}
> > +
> > +late_initcall(disable_early_printk);
> 
> i think we agreed this would be OK/good to have in common code

I didn't hear back from Gerd - and in the past this was implemented in the
arch/*/kernel/early_printk.c - so this is where I put it....

-Robin
