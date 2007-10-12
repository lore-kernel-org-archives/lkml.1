Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbXJLTQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbXJLTQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 15:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbXJLTQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 15:16:12 -0400
Received: from gw.goop.org ([64.81.55.164]:46577 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbXJLTQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 15:16:10 -0400
Message-ID: <470FC7F4.1030300@goop.org>
Date: Fri, 12 Oct 2007 12:16:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>,
       Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@qumranet.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [PATCH RFC REPOST 1/2] paravirt: refactor struct paravirt_ops
 into smaller pv_*_ops
References: <470BC758.1030504@goop.org> <200710101635.10139.rusty@rustcorp.com.au> <470D13CA.3000202@goop.org> <200710120001.52456.rusty@rustcorp.com.au>
In-Reply-To: <200710120001.52456.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> 	Sure, but this can actually be a temporary thing inside the patch code (or at 
> least static to that file if it's too big for the stack).
>
> 	struct paravirt_ops patch_template = { .pv_info = pv_info, .pv_cpu_ops = 
> pv_cpu_ops, ... };
>
> 	Then you can even rename struct paravirt_ops to "struct patch_template" and 
> we're well on the way to making this a generic function-call patching 
> mechanism, rather than something paravirt-specific.
>   

Hm, I see.  I'm not quite sure that's the best way to achieve a generic
result, but I see your point.

> Hope that clarifies my thinking...

Well, I'd agree with making the code more generic if another user
appears, but I'd rather not do it prematurely.

Sorry, I forgot to update lguest.  I'll do that and repost (but I won't
have had a chance to test it).

Are you otherwise happy with the patch in its current form?  And are you
happy with the lazymode changes?

    J

