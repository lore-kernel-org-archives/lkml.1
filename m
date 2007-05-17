Return-Path: <linux-kernel-owner+w=401wt.eu-S1760526AbXEQUKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526AbXEQUKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756802AbXEQUKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:10:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:54819 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287AbXEQUKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:10:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tfrFbrg+XR5HM36ZOrY/ELR+K260vagzK6fS2WcnO0GRVccZ9iA4jKKR3szD27jSqmUXPOoKiCDs/iliZ+JLXYt6ZbtY0zYspa+/YfLm/fz6TITNi+x1jKZNEIY2OmjN6Op2D8fpqN08M28pnYq/xxwPbSF+0QxTqgluqTpA95w=
Message-ID: <4354d3270705171310x1d7770b2mb086f1fde7cffabd@mail.gmail.com>
Date: Thu, 17 May 2007 20:10:01 +0000
From: "=?ISO-8859-1?Q?T=F6r=F6k_Edvin?=" <edwintorok@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: CFS Scheduler and real-time tasks
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070517192343.GA24249@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4354d3270705171214v25bc4834t5e28a08649761e91@mail.gmail.com>
	 <20070517192343.GA24249@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/17/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> note: you ran it on a dual-core system and the SMP load-balancer needs
> time to gain precision in the non-RT test - so i'd suggest to test it
> much longer than 10 seconds: 300 seconds at least.

Thanks, running for 300 seconds shows only a 2% error.
Even running a I/O workload while running the massive_intr test keeps
the same error.
BTW, the system is more 'responsive'. For example starting
applications while running the tests, switching windows, moving
windows is much "smoother" than on default scheduler.

[while true;do cp /usr/portage/distfiles/linux-2.6.21.tar.bz2 . &&
sync && rm linux-2.6.21.tar.bz2 && sync; done]

./massiv_new 9 300
020860  00017782
020858  00017774

RT JOB:020865   00003785

020859  00017048
020862  00017387
020855  00017494
020861  00017245
020863  00017492
020864  00017122


Best regards,
Edwin
