Return-Path: <linux-kernel-owner+w=401wt.eu-S1762115AbXF0UZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115AbXF0UZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbXF0UZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:25:15 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:37652 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbXF0UZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:25:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jTigT8AspD6ShrBLUavDY9RHbw5h1iezfb75aeb0DNfdsqlk0+foJGCYUq0dsdiQ4bVXw3T7Y+kw95fpMXTg6bv9J0olIV+G//fpjt7yFHtf15ZuvA+IjN2kjVY1p6jXKj/kcA0pbYNhtXoCIeGvKIIj6E44lufrWhRaTZMYTQc=
Message-ID: <86802c440706271325w3a8b6d9aybb8a346b9b2eb345@mail.gmail.com>
Date: Wed, 27 Jun 2007 13:25:11 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] x86_64: change _map_single to static in pci_gart.c etc
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200706272222.25153.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706271041.21937.yinghai.lu@sun.com>
	 <200706272222.25153.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/07, Andi Kleen <ak@suse.de> wrote:
> On Wednesday 27 June 2007 19:41:21 Yinghai Lu wrote:
> > [PATCH] x86_64: change _map_single to static in pci_gart.c etc
> >
> > there function is called via dma_ops->.., so change it to static
>
> Actually all these functions shouldn't be inline in the first place.

do you mean pci_map_single==>dma_map_single==>gart_map_single?

YH
