Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbXHEEeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbXHEEeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 00:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbXHEEd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 00:33:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:50627 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbXHEEd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 00:33:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R1Dk6sHrqy8vmXzSKpetL81J6vzn21tztozSd7RotFSUeFuYFeGj9GfSBSzdvVlnBqel6e9pFi0zLChIdmxpxdNiCxXbfmRYT1xjD2m8mgF0z3a6bCntoXTbOSJ1vcmEJ2MhZ4vqdER/coA7Y6bNWXujn/8Vp3V5swEtpdvybLM=
Message-ID: <86802c440708042133u67e61826wc783c97822e4cde1@mail.gmail.com>
Date: Sat, 4 Aug 2007 21:33:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Muli Ben-Yehuda" <muli@il.ibm.com>
Subject: Re: Oops in 2.6.23-rc1-git9, arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       "Andy Whitcroft" <apw@shadowen.org>, "Jeff Garzik" <jeff@garzik.org>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20070805041531.GX25771@rhun.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B3A7BB.9000102@redhat.com> <200708041130.42038.ak@suse.de>
	 <20070804093222.f0d7f3c7.akpm@linux-foundation.org>
	 <200708050140.49590.ak@suse.de> <20070805041531.GX25771@rhun.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/07, Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> On Sun, Aug 05, 2007 at 01:40:49AM +0200, Andi Kleen wrote:
>
> > > "pci device ensure sysdata initialised", now at version 4.
> >
> > Oh what a mess. I think I'll ask Linus to revert the sysdata patch
> > instead. Clearly the stuff is half-baked
>
> Personally I don't care that much, but I think you'll make jgarzik
> very unhappy. The idea is also clearly the right way forward.
>
> So far we know of a single regression and only with 'pci=noacpi'. How
> about giving us a little bit of time to get to the bottom of it?
> Unfortunately it's not reproducable on any of my machines, but I'm
> looking into it.
>

I hope we can use .node and .iommu in pci_bus...

YH
