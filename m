Return-Path: <linux-kernel-owner+w=401wt.eu-S1422800AbXCWLUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422800AbXCWLUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 07:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422791AbXCWLUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 07:20:04 -0400
Received: from mtaout5.012.net.il ([84.95.2.13]:45974 "EHLO mtaout5.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422801AbXCWLUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 07:20:03 -0400
Date: Fri, 23 Mar 2007 13:19:59 +0200
From: Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] Cleanup: rationalize paravirt wrappers
In-reply-to: <1174647912.7642.4.camel@localhost.localdomain>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>
Message-id: <4603B7DF.6000202@qumranet.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Fri,
 23 Mar 2007 13:19:59 +0200 (IST)
References: <1174531311.2713.86.camel@localhost.localdomain>
 <1174647912.7642.4.camel@localhost.localdomain>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> 4) Access to the native versions is trivial for KVM, lguest, Xen and
>    others who might want it.
>   

kvm will be quite happy with it, as long as the x86_64 version has a 
similar API.

include/asm-x86 anyone? ;-)

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

