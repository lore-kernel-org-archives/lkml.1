Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbYHNJBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbYHNJBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbYHNJBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:01:08 -0400
Received: from www.tglx.de ([62.245.132.106]:60936 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbYHNJBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:01:07 -0400
Date: Thu, 14 Aug 2008 11:00:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Milan Plzik <milan.plzik@gmail.com>
cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Possible CPU_IDLE bug [WAS: Re: Timer unstability on when using
 C2 and deeper sleep states (Dell Latitude XT)]
In-Reply-To: <1218701151.4285.9.camel@localhost>
Message-ID: <alpine.LFD.1.10.0808141100100.3243@apollo.tec.linutronix.de>
References: <1218566008.13866.41.camel@localhost>  <1218625125.4304.7.camel@localhost> <1218636980.5250.12.camel@localhost>  <7E82351C108FA840AB1866AC776AEC460945BB44@orsmsx505.amr.corp.intel.com>  <1218658873.4336.15.camel@localhost> 
 <7E82351C108FA840AB1866AC776AEC460945BFF2@orsmsx505.amr.corp.intel.com> <1218701151.4285.9.camel@localhost>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, Milan Plzik wrote:
>   I tried it just now, is performs a bit better than 2.6.26 (e.g. I
> don't get that "press any key unless nothing happens" states), even
> reports a bit more reasonable values of wakeups, but the system
> sometimes becomes rather slow (e.g. when playing video). I was not able
> to compile fglrx driver, so I had to change it to radeon one. And also,
> the number of wakeups reported is not very convincing, though, it
> changes from 300 to 600 (which is ~ two times the sum of wakeups)
> without any reason, and sometimes goes even higher.
> 
>   I tried to use nolapic_timer option, but it didn't help.

Can you please try "hpet=disable" on the kernel command line ?

Thanks,
	tglx
