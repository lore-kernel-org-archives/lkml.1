Return-Path: <linux-kernel-owner+w=401wt.eu-S1751709AbXCEXDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbXCEXDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXCEXDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:03:16 -0500
Received: from gw.goop.org ([64.81.55.164]:58182 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbXCEXDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:03:15 -0500
Message-ID: <45ECA1B1.40102@goop.org>
Date: Mon, 05 Mar 2007 15:03:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [patch] paravirt: VDSO page is essential
References: <20070305225859.236021800E5@magilla.sf.frob.com>
In-Reply-To: <20070305225859.236021800E5@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> Jan Beulich just posted a patch to do just this - relocate the vdso's
>> ELF header.  If that's all that's really required to keep COMPAT_VDSO
>> viable under PARAVIRT, then it seems like the way to go.
>>     
>
> I found http://marc.theaimsgroup.com/?l=xen-devel&m=117309332600075&w=2 and
> that must be the one you meant.  The ELF-grokking form of that is exactly
> what I had in mind.  The "find relocs with cmp" scheme is pretty silly, but
> also works fine.  It trades tweaky ELF knowledge with tweaky fragile build
> methods, but it's all about the same to me.  
>   

That's the one.  I think the C version is the one to go with.

    J
