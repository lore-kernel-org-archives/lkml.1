Return-Path: <linux-kernel-owner+w=401wt.eu-S1750763AbXCNIhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750763AbXCNIhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 04:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbXCNIhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 04:37:12 -0400
Received: from fizeau.zen.co.uk ([212.23.8.67]:57497 "EHLO fizeau.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbXCNIhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 04:37:11 -0400
Message-ID: <45F7B3BB.1030404@gmail.com>
Date: Wed, 14 Mar 2007 08:35:07 +0000
From: Matt Keenan <tank.en.mate@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: copy_one_pte()
References: <45F6F84D.20302@free.fr> <20070313191844.GA4206@infradead.org>
In-Reply-To: <20070313191844.GA4206@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Rutherford-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Mar 13, 2007 at 08:15:25PM +0100, Zoltan Menyhart wrote:
>   
>> I had a look at copy_one_pte().
>> I cannot see any ioproc_update_page() call, not even for the COW pages.
>> Is it intentional?
>>     
>
> There is no such thing as ioproc_update_page in any mainline tree.
> You must be looking at some vendor tree with braindead patches applied.
>
>   
It looks like this function exists as a part of patches to support 
Quadrics NICs / RDMA (HPC platforms).  The patches are there so the 
driver doesn't need to pin pages, it can be informed of page updates 
directly.  A patch was submitted to l-k sometime in 2005.

Matt
