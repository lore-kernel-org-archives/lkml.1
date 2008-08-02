Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYHBCBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYHBCBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 22:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYHBCB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 22:01:27 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:14462 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYHBCB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 22:01:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=btI22C/Ccb8j9VisvAd+T5axhVY2Clo2d1jifxWIlx8No1hm1SQ4wlZkUQkrVOqvaH
         dbF3HYDLrO+p6hUBPYw0NzYNosYkYRiAGX8/8Wa/jsD290YroOZcX/y6PHEsJlsdCCmj
         GsYdHWvvjkYcoW8WrpFuu1O0+AJQ9QTidMptc=
Message-ID: <86802c440808011901w2aa40b25u45f5686b262cc2aa@mail.gmail.com>
Date: Fri, 1 Aug 2008 19:01:24 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m163qkjirc.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
	 <m1iqukwjjg.fsf@frodo.ebiederm.org>
	 <86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>
	 <m1wsj0nyx6.fsf@frodo.ebiederm.org>
	 <86802c440808011809t275aa511h4a1e9d70ede21702@mail.gmail.com>
	 <m163qkjirc.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> cpu is going to check that vectors in addition to vectors in IDT?
>
> No. The destination cpu and destination vector number are encoded in
> the MSI message.  Each MSI-X source ``vector'' has a different MSI message.
>
> So on my wish list is to stably encode the MSI interurrpt numbers.  And
> using a sparse irq address space I can.  As it only takes 28 bits to hold
> the complete bus + device + function + msi source [ 0-4095 ]
>

how about ioapic interrupt numbers...? they should stay with same
numbering with gsi?

and how about pci segments : that will need another 4 bits for AMD
systems..aka 16 segments..

you will run out of 32bits...

BTW:
kstat_irqs patch is there.
How are the progress with irq_cfg/irq_desc dyn allocating patch?

YH
