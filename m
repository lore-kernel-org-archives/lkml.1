Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbZGIVpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbZGIVpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZGIVpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:45:42 -0400
Received: from www.tglx.de ([62.245.132.106]:51910 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbZGIVpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:45:42 -0400
Date: Thu, 9 Jul 2009 23:45:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Hemminger <shemminger@vyatta.com>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: Clock incorrect on 2.6.31-rc2
In-Reply-To: <20090709141000.584d199a@nehalam>
Message-ID: <alpine.LFD.2.00.0907092344390.2768@localhost.localdomain>
References: <20090709141000.584d199a@nehalam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, Stephen Hemminger wrote:

NTP expert CC'ed

> My system (desktop Ubuntu 9.0) runs fine with 2.6.30, but with 2.6.31-rc2 it does
> not keep time correctly. Also ntptime reports an error.
> 
> $ ntptime
> ntp_gettime() returns code 5 (ERROR)
>   time ce00daf1.8e997000  Thu, Jul  9 2009 14:09:05.557, (.557029),
>   maximum error 25016 us, estimated error 16 us
> ntp_adjtime() returns code 5 (ERROR)
>   modes 0x0 (),
>   offset 0.000 us, frequency 7.827 ppm, interval 1 s,
>   maximum error 25016 us, estimated error 16 us,
>   status 0x40 (UNSYNC),
>   time constant 4, precision 1.000 us, tolerance 500 ppm,
