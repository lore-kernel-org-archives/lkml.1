Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbYJ2Vkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbYJ2Vkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYJ2Vkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:40:37 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:38832 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbYJ2Vkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:40:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hylrJcaSfn6PnL6HsOsDWyd28ecVLde5OOsRdE57bMU/QjT/5W4H8/e3hpay6Zu7L9
         VjiBGSO9jmas/m4B/5tq/A81FEiNop10MstYeQbNPDcfQLuamJ1emlpVZagWgtMxkMmH
         c1LzsdTrJLPiT9fcLXgHh7tDXmdY8CrNnjrWE=
Message-ID: <21d7e9970810291440w50d15c30o961dad801cf71548@mail.gmail.com>
Date: Thu, 30 Oct 2008 07:40:33 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Dave Jones" <davej@redhat.com>, "Dave Airlie" <airlied@gmail.com>,
       bob.montgomery@hp.com, "Yinghai Lu" <yinghai@kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vojtech@suse.cz" <vojtech@suse.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "chandru@in.ibm.com" <chandru@in.ibm.com>,
       "Joerg Roedel" <joerg.roedel@amd.com>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Pavel Machek" <pavel@ucw.cz>, "Andi Kleen" <ak@linux.intel.com>
Subject: Re: [PATCH] disable CPU side GART accesses
In-Reply-To: <20081029213244.GD24794@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1224107317.2215.238.camel@amd.troyhebe>
	 <20081015234842.GA10999@elte.hu>
	 <1225147341.2215.401.camel@amd.troyhebe> <4906495B.1060506@kernel.org>
	 <1225313564.3428.14.camel@amd.troyhebe>
	 <21d7e9970810291424g369035d4h562b54c676d49aef@mail.gmail.com>
	 <20081029213244.GD24794@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 7:32 AM, Dave Jones <davej@redhat.com> wrote:
> On Thu, Oct 30, 2008 at 07:24:34AM +1000, Dave Airlie wrote:
>
>  > This stops the CPU from using the aperture for most DRI things. I
>  > can't confirm this won't regress working systems
>  > though. The whole AMD GART thing scares me, esp if some of the host
>  > chipsets also have an AGP GART.
>
> The easy cop-out for those in the past has been 'dont support them'.
> It's why we removed some K8 chipset PCI IDs from the via driver for eg.
> iirc, if we leave them unprogrammed, they're essentially irrelevant.
>

I was more going the other way, why use the IOMMU for AGP when it has
other tasks to
do, and we have a host chipset GART.

Granted I've never had an AMD + AGP system to ever care about this.

Dave.
