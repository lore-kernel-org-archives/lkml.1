Return-Path: <linux-kernel-owner+w=401wt.eu-S1762629AbXLTM2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762629AbXLTM2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760148AbXLTM2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:28:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759209AbXLTM23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:28:29 -0500
Message-ID: <476A5FE9.80008@redhat.com>
Date: Thu, 20 Dec 2007 07:28:25 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-------- Original Message --------
Subject: Re: [PATCH 0/5]PCI: x86 MMCONFIG
Date: Wed, 19 Dec 2007 19:44:13 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
To: Robert Hancock <hancockr@shaw.ca>
References: <fa.zIbPFbLub6ANMT5vMxS6hx+dfv0@ifi.uio.no> 
<fa.3T2SqNjavN55hanLOjr3RO+WalE@ifi.uio.no> <4769B368.1030402@shaw.ca>

Robert Hancock wrote:
> Greg KH wrote:
> 
> I think we need more details on why this patch is needed. Also, we 
> already have something like this in arch/x86/pci/mmconfig-shared.c, in 
> the unreachable_devices function. This attempts to detect devices where 
> MMCONFIG cannot access the configuration space (one of these would be at 
> least one device in the AMD K8 built-in northbridge). If this is not 
> sufficient, I would suggest expanding that mechanism instead of adding 
> all this new code.
> 

We thought of doing that. But IIRC, unreachable_devices() only covers
the first 16 buses on segment 0. What happens to the bitmap when you
want to cover all possible buses on all possible segments?

We felt that we had to come up with a more in-line way of doing this.


