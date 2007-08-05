Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbXHEGEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbXHEGEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 02:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbXHEGEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 02:04:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:9335 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbXHEGEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 02:04:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uR3kBsd19cI/WXWhbU7x6aGjBvo4NF5XRDLDg2htvM3jptFfLGZhpZAUE0Z+O78XdctkBDjflMwyfJJeLK16lCi7bje7bc2UJONsgTU04ih//l/xcRRlYKL9lWtFUuoCTe1FxiNCtOdI4+i82RpliwL4RU2g6OAP5bUYvR8fEbU=
Message-ID: <86802c440708042304t7c4fba22neb3c2ccf9216a573@mail.gmail.com>
Date: Sat, 4 Aug 2007 23:04:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Oops in 2.6.23-rc1-git9, arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Cc: "Andi Kleen" <ak@suse.de>, "Chuck Ebbert" <cebbert@redhat.com>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <20070804225222.67fd9448.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B3A7BB.9000102@redhat.com>
	 <20070803155035.1fb11c9a.akpm@linux-foundation.org>
	 <200708041130.42038.ak@suse.de>
	 <20070804093222.f0d7f3c7.akpm@linux-foundation.org>
	 <86802c440708041045gd4a70fejf54f8532ff1a46f6@mail.gmail.com>
	 <20070804111532.1d3936fa.akpm@linux-foundation.org>
	 <86802c440708041202s4d165e6co701fe1c1e5c1a5ca@mail.gmail.com>
	 <20070804225222.67fd9448.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 4 Aug 2007 12:02:35 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
> > On 8/4/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Sat, 4 Aug 2007 10:45:31 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> > >
> > > > Andrew,
> > > >
> > > > still need
> > x86_64-get-mp_bus_to_node-as-early-v2.patch is already in the -mm
> >
> > it fixs
> > pirq_peer_trick(void) in irq.c
> > pcibios_fixup_peer_bridges in legacy.c
> >
> > by allocate sd.
> >
>
> I don't understand you much, sorry.  Are you saying that
> x86_64-get-mp_bus_to_node-as-early-v2.patch should be merged in 2.6.23?

Yes.

YH
