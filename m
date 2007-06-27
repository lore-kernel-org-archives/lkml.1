Return-Path: <linux-kernel-owner+w=401wt.eu-S1761507AbXF0OQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507AbXF0OQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbXF0OQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:16:08 -0400
Received: from gw.goop.org ([64.81.55.164]:38353 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbXF0OQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:16:07 -0400
Message-ID: <468270F5.7040408@goop.org>
Date: Wed, 27 Jun 2007 10:15:17 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Tony Luck <tony.luck@intel.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: dma_mapping_ops for i386
References: <46817016.7090400@goop.org> <200706270021.11434.ak@suse.de>
In-Reply-To: <200706270021.11434.ak@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Ok, if you can do it without ifdefs. 
>   

That should be OK.  All the existing i386 mapping operations would just 
have their own ops structure, right?

> And no swiotlb on i386; that is something that is completely broken
> in upstream Xen and needs to be fixed properly anyways.
>   

Hm, OK.  I'm not really familiar with the issues here.  What are they?  
Looks like Jan has made a number of Xen-ish changes to lib/swiotlb.c; 
are more changes be needed?

    J
