Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbXHEG1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbXHEG1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 02:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXHEG13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 02:27:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:45609 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbXHEG12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 02:27:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=No6s48LsJtM8Zci1QIX1C/CAZeOBRn3tpz15iReyq+9J3hsiywBQnYz9tKFhv5Fstf9RIoPkYANbDWQn6eMK4rv5AiWoWeIsSgzEUClxVRUazv/uaHJB7QCNCVfD1L6dNB/pI5KBT6mmdLzThg30tHmQ4BkG9WuE5rAbBL30ybI=
Message-ID: <86802c440708042327x31616819t1607e0cd6aa1348a@mail.gmail.com>
Date: Sat, 4 Aug 2007 23:27:27 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Muli Ben-Yehuda" <muli@il.ibm.com>
Subject: Re: Oops in 2.6.23-rc1-git9, arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <86802c440708042324p13ff5f44y2fc8c3632af56ccc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B3A7BB.9000102@redhat.com>
	 <20070804093222.f0d7f3c7.akpm@linux-foundation.org>
	 <86802c440708041045gd4a70fejf54f8532ff1a46f6@mail.gmail.com>
	 <20070804111532.1d3936fa.akpm@linux-foundation.org>
	 <86802c440708041202s4d165e6co701fe1c1e5c1a5ca@mail.gmail.com>
	 <20070804225222.67fd9448.akpm@linux-foundation.org>
	 <20070805060241.GA15693@rhun.haifa.ibm.com>
	 <86802c440708042307u5f220c0cw3b3bd287eb82aa9c@mail.gmail.com>
	 <20070805061133.GB15693@rhun.haifa.ibm.com>
	 <86802c440708042324p13ff5f44y2fc8c3632af56ccc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/07, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On 8/4/07, Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> > On Sat, Aug 04, 2007 at 11:07:04PM -0700, Yinghai Lu wrote:
> >
> > > You just use my patch plus Andy's patch together...
> >
> > Your patch does other things that in my opinion are not appropriate at
> > this stage for 2.6.23. I am aiming for the minimal change that will
> > fix the regression, and your patch should be considered for 2.6.24.
> >
> if Andi picked my batch v1 version before your sysdata patch, then
> there would be this regression
i mean:
if Andi picked up my batch v1 version before your sysdata patch, then
there would not be this regression
YH
