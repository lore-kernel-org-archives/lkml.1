Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbXF1Nwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbXF1Nwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 09:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbXF1Nwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 09:52:45 -0400
Received: from gw.goop.org ([64.81.55.164]:42214 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbXF1Nwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 09:52:45 -0400
Message-ID: <4683BCF2.2080502@goop.org>
Date: Thu, 28 Jun 2007 09:51:46 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Matt Mackall <mpm@selenic.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] Fix lguest w/ lockdep
References: <20070628001425.GR11115@waste.org> <1183037519.6211.2.camel@localhost.localdomain>
In-Reply-To: <1183037519.6211.2.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wed, 2007-06-27 at 19:14 -0500, Matt Mackall wrote:
>   
>> lguest: unhandled trap 14 at 0xc01362f7 (0x0)
>> Dump of assembler code for function __lock_acquire:
>>     
>
> Thanks for the bug report Matt!  I wonder if other
> paravirt_disable_iospace users have the same issue...
>   

I call it a little later (from arch_setup), and I think lockdep_init 
will have already been called at that point.  Hm, yes, it gets called at 
the top of start_kernel.

    J
