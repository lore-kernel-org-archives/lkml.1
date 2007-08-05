Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbXHEGYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbXHEGYn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 02:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXHEGYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 02:24:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:40645 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbXHEGYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 02:24:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cX2C6M5+pvX/b3auiIbsuDTm3HXAsd6di6MDFRh5PR0bUqED7TCbP/7cxbKe7mmEvof5iih/V2lrV2IeuTLk8QvNaDyxGPyzMFAia+v3kUuD9a4Uj2KLDjWSkGEX1JALPpPUUvOVWxdToBokmyexYL6o1wQpAilrJ4d5+h0v0LM=
Message-ID: <86802c440708042324p13ff5f44y2fc8c3632af56ccc@mail.gmail.com>
Date: Sat, 4 Aug 2007 23:24:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Muli Ben-Yehuda" <muli@il.ibm.com>
Subject: Re: Oops in 2.6.23-rc1-git9, arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <20070805061133.GB15693@rhun.haifa.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B3A7BB.9000102@redhat.com> <200708041130.42038.ak@suse.de>
	 <20070804093222.f0d7f3c7.akpm@linux-foundation.org>
	 <86802c440708041045gd4a70fejf54f8532ff1a46f6@mail.gmail.com>
	 <20070804111532.1d3936fa.akpm@linux-foundation.org>
	 <86802c440708041202s4d165e6co701fe1c1e5c1a5ca@mail.gmail.com>
	 <20070804225222.67fd9448.akpm@linux-foundation.org>
	 <20070805060241.GA15693@rhun.haifa.ibm.com>
	 <86802c440708042307u5f220c0cw3b3bd287eb82aa9c@mail.gmail.com>
	 <20070805061133.GB15693@rhun.haifa.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/07, Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> On Sat, Aug 04, 2007 at 11:07:04PM -0700, Yinghai Lu wrote:
>
> > You just use my patch plus Andy's patch together...
>
> Your patch does other things that in my opinion are not appropriate at
> this stage for 2.6.23. I am aiming for the minimal change that will
> fix the regression, and your patch should be considered for 2.6.24.
>
if Andi picked my batch v1 version before your sysdata patch, then
there would be this regression

YH..
