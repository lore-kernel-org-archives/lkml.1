Return-Path: <linux-kernel-owner+w=401wt.eu-S1751735AbXA0Acm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbXA0Acm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 19:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbXA0Acm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 19:32:42 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:60232 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbXA0Acl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 19:32:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=b6q/rCfNe3aFeGyPmfhFlrAzbmqDR4aGeWKg1wwDKkvJEsL6q8ImqRzkGTADU+fF04beeYDtRbx38dFG/UWYqz9on/4HidndEG2mYdFLPd+e9IGLnxdDWFGIOWyKPJHTRMhwafN7mUAOFvi8g5LANC2JcfxNHQoYzc17G6Rh/Z8=
Message-ID: <75b66ecd0701261632q1a93b487u81539d850df10db0@mail.gmail.com>
Date: Fri, 26 Jan 2007 19:32:40 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Hans-Peter Jansen" <hpj@urpla.net>
Subject: Re: prioritize PCI traffic ?
Cc: linux-kernel@vger.kernel.org,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Soeren Sonnenburg" <kernel@nn7.de>
In-Reply-To: <200701172122.27407.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1168859265.15294.8.camel@localhost>
	 <1168869630.15294.44.camel@localhost>
	 <45AB956A.5070103@linux.vnet.ibm.com>
	 <200701172122.27407.hpj@urpla.net>
X-Google-Sender-Auth: a13e7f12ebbc77c4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/07, Hans-Peter Jansen <hpj@urpla.net> wrote:
> Am Montag, 15. Januar 2007 15:53 schrieb Vaidyanathan Srinivasan:
> >
> > 33Mhz 32-bit PCI bus on typical PC can do around 100MB/sec...
>
> Substract roughly n * 5MB for VIA chipsets, where n is the age (1 <= n <=
> 4), and even more for SIS, ATI..

While developing the latency tracer in the -rt kernel, Ingo and others
discovered that some SATA controllers can produce very bad DMA
starvation at higher speeds.  A latency trace of such an event looks
like the entire system is going in slow motion.  Presumably, vendors
do this to improve benchmark scores.

Try forcing your drives to a lower speed.

Lee
