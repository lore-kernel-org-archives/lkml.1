Return-Path: <linux-kernel-owner+w=401wt.eu-S1752708AbXBFEyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbXBFEyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 23:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbXBFEyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 23:54:18 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37640 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752708AbXBFEyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 23:54:18 -0500
Message-ID: <45C809F9.2090905@vmware.com>
Date: Mon, 05 Feb 2007 20:54:17 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 0/11] VMI / Paravirt bugfixes for 2.6.21
References: <200702060352.l163q87K000713@zach-dev.vmware.com> <1170736029.29293.31.camel@localhost.localdomain>
In-Reply-To: <1170736029.29293.31.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Mon, 2007-02-05 at 19:52 -0800, Zachary Amsden wrote:
>   
>> A bunch of VMI and paravirt-ops bugfixes for upstream.  Also, fix the
>> timer code to work for 2.6.21, which had a number of changes.
>>
>> These should mostly be non-controversial and beneficial to all the
>> paravirt-ops work.
>>     
>
> Indeed, I'm expecting to push lguest this week, and this code will
> effect me, so I'd like to see this in a -mm soon...
>
> Thanks!
> Rusty.
>   

Yes, I took a look at the lguest changes today and I think these won't 
generate conflicts, just make stuff easier for you ;)  Course you've now 
got a couple new paravirt-ops to support, but the native ones are fine 
for temporary use.

Cheers,
Zach
