Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbXJZTlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbXJZTlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbXJZTlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:41:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33623 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbXJZTlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:41:09 -0400
Message-ID: <47224295.2020406@zytor.com>
Date: Fri, 26 Oct 2007 12:40:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Zachary Amsden <zach@vmware.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: Fix boot protocol KEEP_SEGMENTS check.
References: <m1r6jh3hun.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6jh3hun.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> The kernel only ever supports 1 version of the boot protocol
> so there is no need to check the boot protocol revision to
> see if a feature is supported.
> 
> Both x86 and x86_64 support the same boot protocol so we need
> to implement the KEEP_SEGMENTS on x86_64 as well.  It isn't
> just paravirt bootloaders that could use this functionality.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Vivek Goyal <vgoyal@in.ibm.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Zachary Amsden <zach@vmware.com>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>

Btw, Acked-by: H. Peter Anvin <hpa@zytor.com>
