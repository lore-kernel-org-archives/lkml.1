Return-Path: <linux-kernel-owner+w=401wt.eu-S939143AbYCSVwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939143AbYCSVwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932303AbYCSUUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:20:25 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:36409 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759156AbYCSUUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:20:20 -0400
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
From: Zachary Amsden <zach@vmware.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Ian Campbell <ijc@hellion.org.uk>
In-Reply-To: <patchbomb.1205797011@localhost>
References: <patchbomb.1205797011@localhost>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 14:33:44 -0700
Message-Id: <1205876024.28104.17.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I looked over these and everything looks fine to me.  I didn't test them
though, since I'm not working on a git tree right now, but be sure to do
a whole slew of compile testing - those demacroizations can trip up in
random places hidden under config options like HIGHPTE.

Zach

Acked-by: Zachary Amsden <zach@vmware.com>

On Mon, 2008-03-17 at 16:36 -0700, Jeremy Fitzhardinge wrote:
> Hi Ingo,
> 
> This is a great big pile of x86 unification and Xen bugfix patches.
> They build and boot for me on 64-bit and 32-bit (PAE and non-PAE).
> 
> Patches are based on x86.git#testing as of this morning.
> 
> The overview:
> 
>  - a couple of Xen bugfixes, which are 2.6.24 and 2.6.25 material
>  - a bunch of x86 cleanups and unifications, mostly around pgalloc
>  - some Xen fixes and improvements:
>    - unify PAE/non-PAE pagetable handling
>    - implement sysenter where applicable
> 
> Thanks,
> 	J
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

