Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbXIOIBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbXIOIBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 04:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbXIOIAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 04:00:54 -0400
Received: from il.qumranet.com ([82.166.9.18]:34340 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbXIOIAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 04:00:53 -0400
Message-ID: <46EB9134.8070505@qumranet.com>
Date: Sat, 15 Sep 2007 11:00:52 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Nakajima, Jun" <jun.nakajima@intel.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Jeremy Fitzhardinge <jeremy@goop.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com><46EAF4C6.8090903@goop.org>	<46EAF6FC.80207@codemonkey.ws><46EAFBA0.4020503@goop.org>	<46EB0136.6080105@codemonkey.ws><46EB02BA.6030909@goop.org>	<46EB0657.40603@codemonkey.ws> <97D612E30E1F88419025B06CB4CF1BE10379EBF9@scsmsx412.amr.corp.intel.com>
In-Reply-To: <97D612E30E1F88419025B06CB4CF1BE10379EBF9@scsmsx412.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Sat, 15 Sep 2007 11:00:52 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nakajima, Jun wrote:
> To me this is the beginning of fragmentation. Why do we need different
> and VMM-specific Linux paravirtualization for hardware-assisted
> virtualization? That would not be good for Linux.
>
>   

The only way to have a single interface is if a central authority
defines and documents that interface, and all hypervisor implementors
agree not to implement extensions.  Do you see that happening?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

