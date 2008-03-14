Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYCNIJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYCNIJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 04:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYCNII5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 04:08:57 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:23670
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbYCNIIz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 04:08:55 -0400
Message-Id: <47DA40D4.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Fri, 14 Mar 2008 08:09:40 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: bitops asm constraint fixes
References: <47D8FD33.76E4.0078.0@novell.com> <47DA2E6F.5080907@zytor.com>
In-Reply-To: <47DA2E6F.5080907@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin" <hpa@zytor.com> 14.03.08 08:51 >>>
>Jan Beulich wrote:
>> 
>> I'd really like understand, though, what the policy of (not) having a
>> "memory" clobber in these operations is - currently, this appears to
>> be totally inconsistent. Also, many comments of the non-atomic
>> functions say those may also be re-ordered - this contradicts the use
>> of "asm volatile" in there, which again I'd like to understand.
>> 
>
>In general, proper "m" constraints are better than "memory" clobbers, 
>since they give gcc more information.  Note that the "m" constraint 
>doesn't actually have to be *manifest* in the assembly string.

... which is the case with the patch applied.

So am I taking this as 'yes, a proper re-write of these routines is
worthwhile'? But - you didn't comment on the other issues raised,
so before getting to that I'll have to wait to see what's the reason
(if any) for the other anomalies.

Jan

