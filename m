Return-Path: <linux-kernel-owner+w=401wt.eu-S932996AbXBPK6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbXBPK6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932991AbXBPK6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:58:41 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:54992 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932996AbXBPK6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:58:40 -0500
Message-ID: <45D58D88.5020801@vmware.com>
Date: Fri, 16 Feb 2007 02:55:04 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Keir Fraser <keir@xensource.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
       Andi Kleen <ak@muc.de>, Dan Hecht <dhecht@vmware.com>,
       linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       Ian Pratt <ian.pratt@xensource.com>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Hand <steven.hand@cl.cam.ac.uk>
Subject: Re: [Xen-devel] Re: [patch 14/21] Xen-paravirt: Add XEN config options
 and disable unsupported config options.
References: <C1FB3B72.98E5%keir@xensource.com>
In-Reply-To: <C1FB3B72.98E5%keir@xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
> On 16/2/07 10:19, "Zachary Amsden" <zach@vmware.com> wrote:
>
>   
>> Doesn't stop_machine_run already take care of getting you out of all
>> kernel threads?  So you can only be sleeping, not preempted, in which
>> case, this might not be an issue?
>>     
>
> It ensures that no (non-stopmachine) threads are running on any of the other
> CPUs, but it doesn't guarantee that all threads are at any form of quiescent
> point. They can certainly have private references to machine addresses.
>
> Otherwise, what would be the point of the process freezer? :-)
>   

Yeah, I was over-hoping on that one.  At least thought it was worth 
suggesting as a starting point.  I had similar issues considering 
loading VMI as a module at runtime.

Zach
