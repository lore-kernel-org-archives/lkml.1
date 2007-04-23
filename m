Return-Path: <linux-kernel-owner+w=401wt.eu-S1751612AbXDWXLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbXDWXLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbXDWXLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:11:32 -0400
Received: from gw.goop.org ([64.81.55.164]:38965 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbXDWXL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:11:26 -0400
Message-ID: <462D3D31.1090702@goop.org>
Date: Mon, 23 Apr 2007 16:11:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 04/25] xen: Add XEN config options
References: <20070423215638.563901986@goop.org> <20070423215709.990824532@goop.org> <200704240100.31011.ak@suse.de>
In-Reply-To: <200704240100.31011.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Monday 23 April 2007 23:56:42 Jeremy Fitzhardinge wrote:
>   
>> The XEN config option enables the Xen paravirt_ops interface, which is
>> installed when the kernel finds itself running under Xen.
>>
>> Xen is no longer a sub-architecture, so the X86_XEN subarch config
>> option has gone.
>>
>> Xen is currently incompatible with PREEMPT, but this is fixed up later
>> in the series.
>>     
>
> Shouldn't this be after the change that adds arch/i386/xen/Kconfig?
>
> Otherwise you break bisects
>   

It should be OK.  The series should build and run at each patch (though
I have to admit I haven't tested this).  In general I've been adding
config options for each feature as the feature itself is added.

    J
