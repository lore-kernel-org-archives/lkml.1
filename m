Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbYANJPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbYANJPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:15:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYANJOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:14:53 -0500
Received: from relay2.sgi.com ([192.48.171.30]:40361 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751638AbYANJOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:14:52 -0500
Message-ID: <478B2806.3000300@sgi.com>
Date: Mon, 14 Jan 2008 10:14:46 +0100
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Cliff Wickman <cpw@sgi.com>, airlied@linux.ie, benh@kernel.crashing.org,
       michael@ellerman.id.au, jk@ozlabs.org,
       Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [rfc][patch] reimplement nopfn callers with fault
References: <20080108113221.GA460@wotan.suse.de> <47877FCA.8050707@sgi.com> <20080112093436.GB25048@wotan.suse.de>
In-Reply-To: <20080112093436.GB25048@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Fri, Jan 11, 2008 at 03:40:10PM +0100, Jes Sorensen wrote:
>> Nick,
>>
>> Is this supposed to apply to the latest Linus tree? I applied it here
>> and the mspec driver lights up in beautiful fireworks :-( I'll give the
>> -mm tree a try next.
> 
> Hi Jes,
> 
> (reply to all this time).
> 
> It is the BUG_ON(vma->vm_flags & VM_PFNMAP); at the start of __do_fault, by
> the looks. That should be simply removed. Sorry about that.

Hi Nick,

Ok, I pulled that line and now mspec is working as expected for me.
I'll throw in an ACK for your patch then.

Acked-by: Jes Sorensen <jes@sgi.com>

Cheers,
Jes
