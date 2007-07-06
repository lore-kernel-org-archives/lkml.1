Return-Path: <linux-kernel-owner+w=401wt.eu-S1764088AbXGFU20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764088AbXGFU20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762333AbXGFU2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:28:18 -0400
Received: from gw.goop.org ([64.81.55.164]:56043 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761037AbXGFU2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:28:18 -0400
Message-ID: <468EA5E0.4070501@goop.org>
Date: Fri, 06 Jul 2007 13:28:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] VMI: remove CONFIG_DEBUG_PAGE_TYPE and associated	bitrotted
 code
References: <Pine.LNX.4.64.0707060847470.23786@localhost.localdomain>	<468E890A.1070504@s5r6.in-berlin.de>	<20070706201625.GT4306@sequoia.sous-sol.org> <468EA27C.9060401@vmware.com>
In-Reply-To: <468EA27C.9060401@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> I'd rather keep it, even with bitrot - it was non-trivial to get 
> correct, and found many surprises in the code; most notably, it can 
> detect
>
> 1) PTE writes to pages not declared as page tables
> 2) Failure to allocate or de-allocate page tables using the 
> paravirt-ops API
> 3) PTE writes using the wrong level operations
>
> These are most useful properties; in fact, I would like to extend the 
> code for 64-bit paravirt-ops and 4-level paging, so rather not kill it 
> until then.
>
> I never merged the whole bit upstream because it added a field to 
> struct page. 

Hm, is that a big problem?  It would be OK for a debug config option, 
wouldn't it?  Also, it doesn't seem particularly vmi-specific.  Could it 
be made part of the pvops infrastructure?

    J
