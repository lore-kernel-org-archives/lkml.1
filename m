Return-Path: <linux-kernel-owner+w=401wt.eu-S1422808AbXBUSzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422808AbXBUSzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422809AbXBUSzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:55:40 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:41577 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422808AbXBUSzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:55:37 -0500
Message-ID: <45DC95A8.1090907@vmware.com>
Date: Wed, 21 Feb 2007 10:55:36 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andi Kleen <ak@muc.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 00/21] Xen-paravirt: Xen guest implementation for paravirt_ops
 interface
References: <20070216022449.739760547@goop.org> <Pine.LNX.4.64.0702161244380.26718@schroedinger.engr.sgi.com> <45D61C74.2000601@vmware.com> <Pine.LNX.4.64.0702161312460.28871@schroedinger.engr.sgi.com> <45D626BB.20007@vmware.com> <Pine.LNX.4.64.0702161356380.29218@schroedinger.engr.sgi.com> <20070217135112.GA15102@muc.de> <Pine.LNX.4.64.0702211036060.24941@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702211036060.24941@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Sat, 17 Feb 2007, Andi Kleen wrote:
>
>   
>> That was always its intention. It's not a direct interface to a hypervisor,
>> but an somewhat abstracted interface to a "hypervisor driver" 
>>     
>
> I thought that hypervisor driver was some binary blob that can be directly
> accessed via paravirt_ops?
>   

There are no more binary blobs being used by paravirt-ops hypervisors.  
I prefer the term "open hypercode layer".


>> But you're right that there are currently still quite a lot of hooks
>> being added. I plan to be much more strict on that in the future.
>>     
>
> And it seems that the hooks are not generic but bound to a particular 
> hypervisor. Should the Xen specific stuff not be in the binary blob?
>   

Xen doesn't use a hypercode layer, and there is no way to do what they 
need to do without hooks in the kernel.

Zach
