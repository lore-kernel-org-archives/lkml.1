Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbYBSQMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbYBSQMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYBSQML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:12:11 -0500
Received: from relay2.sgi.com ([192.48.171.30]:57561 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752778AbYBSQMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:12:10 -0500
Message-ID: <47BAFFD3.1070606@sgi.com>
Date: Tue, 19 Feb 2008 08:12:03 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: 2.6.24 git2/mm1: cpu_to_node mapping to non-existant nodes causing
 boot failure
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <20080213175241.GA327@csn.ul.ie> <47B33ACF.5030700@sgi.com> <20080214201727.GC30841@csn.ul.ie> <47B4A774.7050509@sgi.com> <20080215020208.GA6500@csn.ul.ie> <47B77E90.5050809@sgi.com>
In-Reply-To: <47B77E90.5050809@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Mel Gorman wrote:
> 
>> If you send me patches to apply on top of 2.6.25-rc1, I'll give them a spin
>> on the machine in question. Reverting didn't work out very well as there are
>> too many collisions with patches that were applied later. I eventually got
>> the machine booting but it only succeeds because it only brings up one core
>> on each processor.  The patch, which is pretty brain damaged is below in case
>> it helps you guess what the real problem is. dmesg logs are attached of the
>> vanilla failure with acpi=debug and the log with the patch applied showing
>> "__cpu_up: bad cpu 1" and "__cpu_up: bad cpu3" (i.e. the second cores of
>> each machine).
>>
> 
> This should completely undo the change to 16 bit apic ids until we can figure
> out the problem with the memory-less nodes.  I checked it on both the numa
> and non-numa x86_64 box.
> 
> Thanks,
> Mike
> 

Hi Mel,

Did you get a chance to try out this patch to see if it cleared up the problem
booting on your x86_64 numa box?

Thanks,
Mike
