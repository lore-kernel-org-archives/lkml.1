Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYHGAFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYHGAFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbYHFXuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 19:50:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57069 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753206AbYHFXut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 19:50:49 -0400
Date: Thu, 7 Aug 2008 00:26:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/33] dyn_array and nr_irqs support v4
Message-ID: <20080807002638.04699eac@lxorguk.ukuu.org.uk>
In-Reply-To: <m1y739j2z8.fsf@frodo.ebiederm.org>
References: <1218011937-10084-1-git-send-email-yhlu.kernel@gmail.com>
	<m1hc9yjb7x.fsf@frodo.ebiederm.org>
	<86802c440808061129l2bbe1658w453a11b4f16ffc83@mail.gmail.com>
	<m1y739j2z8.fsf@frodo.ebiederm.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2008 13:35:55 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> 
> >> My suggestion for a non-breaking path:
> >> - Kill NR_IRQS in then generic code.
> >>  With Alan's serial patch and my kstat patch it looks like we have
> >>  the worst of that.
> >
> > will use Alan's patch.at first.
> > already reused your patch about kstat. and move kstat_irqs to irq_desc.
> 
> Part of what I am thinking is that there should never be a patch
> that does s/NR_IRQS/nr_irqs/ that is just pointless noise.
> 
> Either we need a new abstraction like for_each_irq or to update the
> code to the current best practices.
> 
> Which means the patches should be uncontroversial and mergeble on their
> own with no weird dependencies.

A lot of these are range checks so could be replaced by a single
valid_irq(irq) test.

Alan
