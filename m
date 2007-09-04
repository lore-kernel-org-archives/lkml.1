Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbXIDGzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbXIDGzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 02:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXIDGzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 02:55:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:52754 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbXIDGzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 02:55:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hD6/s6Ayk4wzx1gS9jbRBHHex/eh6BE2Sprz7wq+rfhBof0k7qmPVvOWoKh+Fx2kfy3pdBboNutiwjBE2eQnRhBXo2KVvxAoe5m3bxZx2ToQZpTnFmMQhmW4nelmHKzuZWEUUmNs0k+GQFJkrq8y+amcaDZ2oDJmbJbegEe6WLQ=
Message-ID: <86802c440709032354w46395c72m954e53b5685be11e@mail.gmail.com>
Date: Mon, 3 Sep 2007 23:54:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access for AMD Barcelona
Cc: "Robert Richter" <robert.richter@amd.com>, patches@x86-64.org,
       "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200709031448.42285.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070830174311.221133000@amd.com> <200709031215.03473.ak@suse.de>
	 <20070903112746.GH7916@erda.amd.com> <200709031448.42285.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/07, Andi Kleen <ak@suse.de> wrote:
> On Monday 03 September 2007 13:27, Robert Richter wrote:
>
> > On 03.09.07 12:15:03, Andi Kleen wrote:
> > > > But it is needed for some devices for full functionality.
> > >
> > > Examples? I can only think of PCI express error reporting, which
> > > few drivers implement anyways and isn't really a show stopper
> > > if it doesn't work. Besides I would be surprised if it even works
> > > on the cheap desktop boards which have MCFG less BIOS.
> >
> > As you say, there are BIOSs that do not support MMCONFIG. Thus, CF8
> > access is not only a workaround to boot a system.
>
> We're talking about accessing the extended part of config spaces. I'm not
> aware of any case where that is required to boot a system.

in the bios for the new cpu, CF8 is used for ext conf space
accessing...(for ht and mem init).

for setting mmio to accessing pci conf space, need to set sth on MSR.
So the BIOS need to make it right..., otherwise OS need to set that
when booting every cpu...to workaround it to make MMCONFIG working.

YH
