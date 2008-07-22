Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbYGVVTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbYGVVTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbYGVVPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:15:51 -0400
Received: from outbound-mail-16.bluehost.com ([69.89.20.231]:40343 "HELO
	outbound-mail-16.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756769AbYGVVPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:15:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=KCpNN60rT0Ey804eK+9TZm1qeSO9lHFdbxNKfZDc7dWbceOemyhh6E8u2QTVlSontzKU3OGdjq2WuZSD3b19tYKZZgZo84DykEwsKvYBJAK8+ZQPEtcdg8pXzrqze5CD;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Date: Tue, 22 Jul 2008 14:15:37 -0700
User-Agent: KMail/1.9.9
Cc: Jack Howarth <howarth@bromo.msbb.uc.edu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200807180941.09779.yhlu.kernel@gmail.com> <20080719191438.GA19759@bromo.msbb.uc.edu> <1216622999.838.1.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1216622999.838.1.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221415.37576.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 20, 2008 11:49 pm Shaohua Li wrote:
> On Sat, 2008-07-19 at 15:14 -0400, Jack Howarth wrote:
> > On Sat, Jul 19, 2008 at 12:04:48PM -0700, Jesse Barnes wrote:
> > > On Saturday, July 19, 2008 11:40 am Jack Howarth wrote:
> > > > Jesse,
> > > >     It seems that MacBook Pro users aren't the only ones suffering
> > > > from PCIE_ASPM...
> > > >
> > > > http://groups.google.com/group/linux.kernel/browse_thread/thread/cc1b
> > > >8b3ef6 4e3257/dd4e427510bde7f0?lnk=raot
> > > >
> > > > I also discovered the pcie_noaspm kernel option from that thread
> > > > which allows me to boot the kernels built with PCIE_ASPM support by
> > > > disabling that feature.
> > >
> > > Yeah, that's a good data point.  Thanks.  Sounds like there may also be
> > > some ACPI interaction going on...
> > >
> > > Jesse
> >
> > Jesse,
> >    For what its worth, acpi=off alone is insufficent to inhibit the
> > kernel freezes when PCIE aspm is in use.
>
> As Jesse suggested, maybe we should blacklist all pcie pre-1.1 devices.
> please try.

Jack, did this work for you?  I'm thinking of pushing this but want to make 
sure it actually solves your problem first.

Thanks,
Jesse
