Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbXKMPfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbXKMPfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbXKMPfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:35:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbXKMPfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:35:30 -0500
Message-ID: <4739C42F.8030208@redhat.com>
Date: Tue, 13 Nov 2007 10:35:11 -0500
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org, perfmon2-devel@lists.sourceforge.net
Subject: Re: [perfmon2] perfmon2 merge news
References: <20071107003454.GA13374@kroah.com>	<20071109120627.60ec9ab4.akpm@linux-foundation.org>	<20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com>
In-Reply-To: <20071113151718.GA3804@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> On 10.11.07 21:32:39, Andi Kleen wrote:
>> It would be really good to extract a core perfmon and start with
>> that and then add stuff as it makes sense.
>>
>> e.g. core perfmon could be something simple like just support
>> to context switch state and initialize counters in a basic way 
>> and perhaps get counter numbers for RDPMC in ring3 on x86[1]
> 
> Perhaps a core could provide also as much functionality so that
> Perfmon can be used with an *unpatched* kernel using loadable modules?
> One drawback with today's Perfmon is that it can not be used with a
> vanilla kernel. But maybe such a core is by far too complex for a
> first merge.
> 
> -Robert
> 

Hi Robert,

In the past I suggested that it might be useful to have a version of perfmon2 
that only set up the perfmon on a global basis. That would allow the patches for 
context switches to be added as a separate step, splitting up the patch into 
smaller set of patches.

Perfmon2 uses a set of system calls to control the performance monitoring 
hardware. This would make it difficult to use an unpatch kernel unless perfmon 
changed the mechanism used to control the performance monitoring hardware.

-Will
