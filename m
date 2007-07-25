Return-Path: <linux-kernel-owner+w=401wt.eu-S1763578AbXGYLjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763578AbXGYLjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 07:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760396AbXGYLjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 07:39:10 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:50084 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759785AbXGYLjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 07:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s7ekdYqyWwMGZftYj09McblvHNV1QUDDSRo1ZwZjjJju5wjcxbg+dNkFHMAN7JrUKe2ss5/v/GAqy3STvwxK3g1Tgaf2qqpFoxizDY6FpkdS+J/ac3DCy3MDVMHYxRfcqm8F92Ux63rCuZPxPh0q51J1OfFmXiEP9QCnmlEGkAY=
Message-ID: <e9f486400707250439k432d8b6dwb9c3066d7152f0dd@mail.gmail.com>
Date: Wed, 25 Jul 2007 13:39:07 +0200
From: "Henri Hunnekens" <henrihunnekens@gmail.com>
To: "Joachim Deguara" <joachim.deguara@amd.com>
Subject: Re: TSC calibration sometimes not correct with RT patch.
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <200707251230.24311.joachim.deguara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e9f486400707250025k163d34cdk97cf2722db739634@mail.gmail.com>
	 <20070725073949.GB595@elte.hu>
	 <e9f486400707250056i7f6ef2aducef8c0f7cf11c09c@mail.gmail.com>
	 <200707251230.24311.joachim.deguara@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That was also my first idea, however the local_irq_disable() routine
disables the interrupts according to Ingo, so an SMI is not possible.


2007/7/25, Joachim Deguara <joachim.deguara@amd.com>:
> On Wednesday 25 July 2007 09:56:38 Henri Hunnekens wrote:
> > Some more information, the problems occurs on a SMP machine. I've
> > added the system logging which displays the CPU speed. The last line
> > shows an inaccurate processor speed! I'll try an update, but I expect
> > this has something to do with the TSC calibration and that hasn't
> > changed, If I'm correct.
>
> Could it just be that an SMI happened during the calibration?
>
> -Joachim
>
>
>
