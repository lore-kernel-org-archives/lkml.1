Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbYHCGE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbYHCGE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 02:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYHCGEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 02:04:20 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:55558 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYHCGEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 02:04:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UYxO6Mv3IbSzCE6LzBL0hxPZkCvRWgxeBTEWO4Uqct8alPS7W56B8qVpJhRCQGUJ1w
         Zm5jnjqDPt/uDNRxzk/qvl/mGrhNQqXzDlqROeuapqV7zgZ9R8ITCRWiUoI3ph37kx5M
         qPUI8/+yJDtlQIoCQmEqQ/GiwbWbRPkI2hHIY=
Message-ID: <86802c440808022304g41749d9dn7688c81c3fdbed8a@mail.gmail.com>
Date: Sat, 2 Aug 2008 23:04:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 00/25] dyn_array and nr_irqs support v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1fxpm8x3n.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	 <m1fxpm8x3n.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 2, 2008 at 10:51 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> It appears that quite a few of the places you have changed are testing
> to see if an irq is valid.  The idiomatic way to perform that test in
> the kernel is:
>
> if (irq)

is uninitialized irq to be -1 or 0?

>
> With no test to see if you are >= NR_IRQS.
>
> I expect that is the change we want in the drivers that are performing such a silly
> extra check.

is_irq_valid(irq_no) ?

wait to see your new patchset about dyn irq_cfg and irq_desc

YH
