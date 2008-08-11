Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbYHKQak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbYHKQak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbYHKQaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:30:23 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44422 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907AbYHKQaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:30:21 -0400
Date: Mon, 11 Aug 2008 19:28:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: S K <nospamnoham@gmail.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Message-ID: <20080811162839.GA22450@cs181140183.pp.htv.fi>
References: <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com> <200808092059.47863.trenn@suse.de> <514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com> <1218418431.6671.52.camel@yakui_zhao.sh.intel.com> <514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com> <20080811042244.469f8e1d@infradead.org> <20080811140206.GB3338@cs181140183.pp.htv.fi> <20080811071128.0165be50@infradead.org> <20080811160346.GB21292@cs181140183.pp.htv.fi> <20080811092047.42bf716b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080811092047.42bf716b@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 09:20:47AM -0700, Arjan van de Ven wrote:
> On Mon, 11 Aug 2008 19:03:46 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Mon, Aug 11, 2008 at 07:11:28AM -0700, Arjan van de Ven wrote:
> > >...
> > > so before you had for one second "20% expensive, 80% low power" 
> > > now you have for one second "20% expensive, 20% throttle power, 60%
> > > low power"
> > > 
> > > since throttle power is higher than low/idle power.. you lose.
> > 
> > So what is the intended use case?
> >
> 
> it's thermal throttling.
> To forcefully reduce the number of cycles that have the full "execute"
> power in order to clamp the temperature if the cpu is too hot.
> 
> > 
> > There must be a reason why Intels CPUs support this throttling?
> 
> 
> yes there is.. for cases where there is overtemperature. Think of it as
> the emergency break in the subway. You really don't want to use it but
> when you need it you're glad it's there.

But this only helps when the cooling is working but not good enough,
for the classic "fan broken" case it won't cool down enough.

Does the Pentium 4 predate CPUs that shutdown when becoming too hot
(I experienced such a shutdown recently on my Athlon...)?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

