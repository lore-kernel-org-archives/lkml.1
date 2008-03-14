Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYCNHwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYCNHwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 03:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYCNHv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 03:51:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYCNHv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 03:51:57 -0400
Message-ID: <47DA2E6F.5080907@zytor.com>
Date: Fri, 14 Mar 2008 08:51:11 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [RFC] x86: bitops asm constraint fixes
References: <47D8FD33.76E4.0078.0@novell.com>
In-Reply-To: <47D8FD33.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> 
> I'd really like understand, though, what the policy of (not) having a
> "memory" clobber in these operations is - currently, this appears to
> be totally inconsistent. Also, many comments of the non-atomic
> functions say those may also be re-ordered - this contradicts the use
> of "asm volatile" in there, which again I'd like to understand.
> 

In general, proper "m" constraints are better than "memory" clobbers, 
since they give gcc more information.  Note that the "m" constraint 
doesn't actually have to be *manifest* in the assembly string.

	-hpa
