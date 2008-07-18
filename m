Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbYGRXZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbYGRXZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbYGRXZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:25:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50930 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314AbYGRXZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:25:08 -0400
Message-ID: <4881263B.7060700@zytor.com>
Date: Fri, 18 Jul 2008 16:24:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: improve double fault handling
References: <4880A912.76E4.0078.0@novell.com>
In-Reply-To: <4880A912.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Make the double fault handler use CPU-specific stacks. Add some
> abstraction to simplify future change of other exception handlers to go
> through task gates.
> Add a new notification of the event through the die notifier chain,
> also providing some environmental adjustments so that various
> infrastructural things work independent of the fact that the fault and
> the callbacks are running on other then the normal kernel stack.
> 
> Signed-Off-By: Jan Beulich <jbeulich@novell.com>
> Cc: Andi Kleen <andi@firstfloor.org>

This patch doesn't apply for me to the extent that I'm hesitant to fix 
it up manually.  Could you please refresh it against current -linus?

	-hpa

P.S. All your patches came through QP-damaged, which made them more 
difficult to deal with manually.
