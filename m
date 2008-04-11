Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbYDKHRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbYDKHRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 03:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbYDKHRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 03:17:16 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:10002 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbYDKHRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:17:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FgsXU4e2jg+CxM+qJQXpd8dors+3XaQBuHyBfDciYuc/3JmHEqT/qp/Xf+ICuoAptF68zJEv+WOrt1kKmb6XCG4ULjA5LsoAmbdZtjvZomVxMhQcbcmRM5zewo8haLuCtWLcg+qllv58IdkS4TPBV8GzZcsXvHIMoKANxkD80To=
Message-ID: <86802c440804110017y62938d90x7e3e32df25a60d1@mail.gmail.com>
Date: Fri, 11 Apr 2008 00:17:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: regression caused by: genirq: do not leave interupts enabled on free_irq
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jeff Garzik" <jeff@garzik.org>, "Ayaz Abdulla" <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440804110014j44b32d16ubfaa0f327c3a384f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440804102313k4546cd73s7bffb30a14239472@mail.gmail.com>
	 <alpine.LFD.1.10.0804110841370.3261@apollo.tec.linutronix.de>
	 <86802c440804110014j44b32d16ubfaa0f327c3a384f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 12:14 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Fri, Apr 11, 2008 at 12:01 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>  > On Thu, 10 Apr 2008, Yinghai Lu wrote:
>  >  > last week found:
>  >  > after latest kernel kexec RHEL 5.1 or other stack kernel, the nvidia
>  >  > forcedeth doesn't work anymore.
>  >  >
>  >  > I stared at forcedeth.c two days. and revert every patches about that
>  >  > doesn't help.
>  >
>  >  So forcedeth does not come up again, when you kexec from linus.git
>  >  into an older distro kernel. Or is it the other way round ?
>  RHEL 5.1 kexec RHEL 5.1 : works
>  RHEL 5.1 kexec linus kernel: works
>  linus (after -rc2) kexec linus tree: works:
>  linus  (after -rc2) kexec RHEL 5.1 : forcedeth will not come up
>  linus ( before -rc2 include rc2) kexec RHEL 5.1 works
>
the forcedeth can not get IP address...

YH
