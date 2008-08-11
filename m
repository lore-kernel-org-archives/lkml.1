Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbYHKQUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbYHKQUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYHKQUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:20:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:36348 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYHKQUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:20:46 -0400
Date: Mon, 11 Aug 2008 09:20:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: S K <nospamnoham@gmail.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Message-ID: <20080811092047.42bf716b@infradead.org>
In-Reply-To: <20080811160346.GB21292@cs181140183.pp.htv.fi>
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com>
	<200808081430.43012.trenn@suse.de>
	<aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com>
	<200808092059.47863.trenn@suse.de>
	<514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com>
	<1218418431.6671.52.camel@yakui_zhao.sh.intel.com>
	<514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com>
	<20080811042244.469f8e1d@infradead.org>
	<20080811140206.GB3338@cs181140183.pp.htv.fi>
	<20080811071128.0165be50@infradead.org>
	<20080811160346.GB21292@cs181140183.pp.htv.fi>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008 19:03:46 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Mon, Aug 11, 2008 at 07:11:28AM -0700, Arjan van de Ven wrote:
> >...
> > so before you had for one second "20% expensive, 80% low power" 
> > now you have for one second "20% expensive, 20% throttle power, 60%
> > low power"
> > 
> > since throttle power is higher than low/idle power.. you lose.
> 
> So what is the intended use case?
>

it's thermal throttling.
To forcefully reduce the number of cycles that have the full "execute"
power in order to clamp the temperature if the cpu is too hot.

> 
> There must be a reason why Intels CPUs support this throttling?


yes there is.. for cases where there is overtemperature. Think of it as
the emergency break in the subway. You really don't want to use it but
when you need it you're glad it's there.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
