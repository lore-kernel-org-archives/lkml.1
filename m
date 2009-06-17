Return-Path: <linux-kernel-owner+w=401wt.eu-S933884AbZFQOVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884AbZFQOVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933875AbZFQOUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:20:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:12683 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933884AbZFQOUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:20:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vpmdy2zuL95Je9k0gZcgZeVLJeElqHMcTrCFXqzHI63BGGine3gBXpIPuogl4JZVso
         b2enENbPEcIYKH89pBic7anxWqO1Uayzuoy1fLTB3BduKNz6xYwC9Ezn+cEuRcUAd1bF
         wgPNEXj6wJFVwwac7WWoWvYEDwSgObbAicEhE=
Subject: Re: [PATCH]x86-tsc.c : fix compile warning
From: "Figo.zhang" <figo1802@gmail.com>
To: subrata@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Sumit Panchasara <sumit.panchasara@einfochips.com>,
       "'Sachin P Sant'" <sachinp@linux.vnet.ibm.com>,
       "'H. Peter Anvin'" <hpa@zytor.com>, "'Frans Pop'" <elendil@planet.nl>,
       "'Andi Kleen'" <andi@firstfloor.org>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       "'Balbir Singh'" <balbir@linux.vnet.ibm.com>
In-Reply-To: <1245248241.4870.12.camel@subratamodak.linux.ibm.com>
References: <1245247057.3312.2.camel@myhost>
	 <bb33bcf20906170700i4a4ea802yf1da08e9870d6221@mail.gmail.com>
	 <1245248241.4870.12.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Jun 2009 22:20:35 +0800
Message-Id: <1245248435.3312.23.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 19:47 +0530, Subrata Modak wrote:
> > fix compile warning:
> > arch/x86/kernel/tsc.c: In function ‘time_cpufreq_notifier’:
> > arch/x86/kernel/tsc.c:635: warning: ‘dummy’ may be used uninitialized in
> > this function
> > 
> > Signed-off-by: Figo.zhang <figo1802@gmail.com>
> 
> Hello Figo,
> 
> Please refer to the following links on discussion on this issue earlier:
> http://lkml.org/lkml/2009/5/19/312
> http://lkml.org/lkml/2009/5/19/301
> http://lkml.org/lkml/2009/5/20/23
> 
> I tried to fix it in some other way.

hi Subrata,

That is ok.

Best Regards,
Figo.zhang
> 
> Regards--
> Subrata
> 
> > ---
> > arch/x86/kernel/tsc.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> > index ae3180c..e65492a 100644
> > --- a/arch/x86/kernel/tsc.c
> > +++ b/arch/x86/kernel/tsc.c
> > @@ -632,7 +632,7 @@ static int time_cpufreq_notifier(struct
> > notifier_block *nb, unsigned long val,
> >                                void *data)
> >  {
> >        struct cpufreq_freqs *freq = data;
> > -       unsigned long *lpj, dummy;
> > +       unsigned long *lpj, dummy = 0;
> > 
> >        if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
> >                return 0;
> > 
> 
> 

