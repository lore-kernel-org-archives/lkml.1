Return-Path: <linux-kernel-owner+w=401wt.eu-S933476AbXGTVtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbXGTVtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbXGTVtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:49:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:45605 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759567AbXGTVtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MIYoikm7wDjrl3qCjf2UjgrtF3LfXenmPWNUqX2XUIc7I9HbwoEX+yIFR96R8RBj+FIl/RLPXIA5KGWNgVVEZfCJfBg7z95X5/l0fT0wnKvpXUTh7HIv/E/bbTe6kkv9pAO2t1wbxvfhodd602jRuc6Q6ULEOTV+xgxKnskBJ1Y=
Message-ID: <1a297b360707201449q73637216w81859b01ab3e5b7e@mail.gmail.com>
Date: Sat, 21 Jul 2007 01:49:07 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
Cc: "Leech, Christopher" <christopher.leech@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "Nelson, Shannon" <shannon.nelson@intel.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net, jeff@garzik.org,
       "Williams, Dan J" <dan.j.williams@intel.com>
In-Reply-To: <adaveceah8l.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BD524EA7912ED5469DFD0BAEF6BC752F023E842F@orsmsx411.amr.corp.intel.com>
	 <adazm1qai0m.fsf@cisco.com>
	 <1a297b360707201432q3dc976b3x214c2916ca235b6f@mail.gmail.com>
	 <adaveceah8l.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Roland Dreier <rdreier@cisco.com> wrote:
>  > In a case where you have a device that which supports MSI-X (multiple
>  > interrupts) but the device in default is in MSI mode, ie some
>  > configuration change is needed on the device. In such a case, how
>  > would one handle between MSI-X and MSI ?
>  >
>  > ie the device initially doesn't support MSI-X
>
> I don't understand the question really.  Does the PCI spec even allow
> a device to be in MSI mode by default?  Surely the OS must initialize
> the address/message before the device can generate an MSI?
>

Sorry for being not clear. What i was asking is thus:

A device that has legacy interrupts and MSI-X. I was thinking that if
MSI-X failed one should fall back to MSI mode (single message), that's
what i was assuming.

In such a case, i do enable MSI-X mode on the device, when the request
for 2 ^ n  number of messages (where messages can be a max of 32), If
the request fails one falls into a single message mode, ie MSI ?


> What device do you have in mind?


The device that i have in mind is a SAA7160.


> I guess the interesting case is a
> PCIe device that supports MSI and MSI-X but not legacy interrupts.
> However I would assume such a device would come up with both MSI and
> MSI-X disabled.
>
>  - R.
>
