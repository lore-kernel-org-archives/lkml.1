Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbYDOIXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbYDOIXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYDOIXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:23:36 -0400
Received: from rv-out-0708.google.com ([209.85.198.244]:23169 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754276AbYDOIXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:23:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NYVPXdCNU7M8kPkOEPsUcPXkkw1QW5JC5x2dAexvR+HUGKbotwbIkp7FKlgUwI8KLZ2KjKOkNHnZtu8E71XwNCTxqCRelrDj4LxliycyryQEop5IdNfRvllxxP8+CHjReWFgjn/sAaQsTeNCX7910ucKglKpbJOcl6ISGfLE0HI=
Message-ID: <86802c440804150123u5ddc4449sfa97538fe3970149@mail.gmail.com>
Date: Tue, 15 Apr 2008 01:23:32 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: regression caused by: genirq: do not leave interupts enabled on free_irq
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Jeff Garzik" <jeff@garzik.org>,
       "Ayaz Abdulla" <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080415081744.GB19452@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440804102313k4546cd73s7bffb30a14239472@mail.gmail.com>
	 <alpine.LFD.1.10.0804110841370.3261@apollo.tec.linutronix.de>
	 <86802c440804110014j44b32d16ubfaa0f327c3a384f@mail.gmail.com>
	 <86802c440804110017y62938d90x7e3e32df25a60d1@mail.gmail.com>
	 <1207899030.15605.1.camel@x61.ebiederm.org>
	 <86802c440804111122x5c106779g60f1c04ae21fed94@mail.gmail.com>
	 <86802c440804111248je6dfa99va8eec42531f4b689@mail.gmail.com>
	 <20080415004400.bb941191.akpm@linux-foundation.org>
	 <86802c440804150103s59f6fe16ncf08a3154c03d2bb@mail.gmail.com>
	 <20080415081744.GB19452@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 1:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>
> > >  Do we think it's a bug in the RHEL 5.1 kernel?  Even so, that's a
>  > >  problem for the 2.6.25 kernel.
>  >
>  > it is RHEL 5.1 kernel problem, it has code for maskbit with msi there,
>  > but that does work...
typo: should be "that does *not* work"
>
>  addendum - basically the argument is: we should kexec conservatively -
>  i.e. we should leave as few assumptions and hw changes around as
>  possible. So restoring the MSI state is fair enough as a robustness fix,
>  even though only kexec to older kernels is affected.

i keep using kexec back and forth to avoid BIOS post stage.

YH
