Return-Path: <linux-kernel-owner+w=401wt.eu-S1759081AbYDCOho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081AbYDCOho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 10:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757475AbYDCOhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 10:37:37 -0400
Received: from gw.goop.org ([64.81.55.164]:38615 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757402AbYDCOhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:37:36 -0400
Message-ID: <47F4EB77.1010304@goop.org>
Date: Thu, 03 Apr 2008 07:36:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, xen-devel <xen-devel@lists.xensource.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Abd-El-Malek <mabdelmalek@cmu.edu>
Subject: Re: [Xen-devel] [PATCH] xen: Fix grant table bug
References: <47F05DB1.5090606@cmu.edu> <1207229210.29720.11.camel@muff>
In-Reply-To: <1207229210.29720.11.camel@muff>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark McLoughlin wrote:
> On Sun, 2008-03-30 at 23:42 -0400, Michael Abd-El-Malek wrote:
>
>   
>> There was a bug in the free list allocation code. The free list was indexed as 
>> if it was the same size as the grant table.  But it's only half as large.  So 
>> memory got corrupted, and I was seeing crashes in the slab allocator later on.
>>     
>
> Looks like an obvious candidate for upstream linux too. Rebased version
> below.
>   

Queued, thanks.

    J
