Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbXJ3AFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbXJ3AFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 20:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbXJ3AF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 20:05:27 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:53444 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbXJ3AF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 20:05:26 -0400
Message-ID: <4726753D.3010601@ct.jp.nec.com>
Date: Mon, 29 Oct 2007 17:05:17 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: vgoyal@in.ibm.com, tglx@linutronix.de, hbabu@us.ibm.com,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] Revert x86: add lapic_shutdown for x86_64
References: <47195763.1090803@ct.jp.nec.com>	<47195807.6030809@ct.jp.nec.com>	<20071024062933.GA4622@in.ibm.com>	<47266132.5050001@ct.jp.nec.com> <20071029161534.6e7f0db6@laptopd505.fenrus.org>
In-Reply-To: <20071029161534.6e7f0db6@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 29 Oct 2007 15:39:46 -0700
> Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
>> lapic_shutdown is useless on x86_64.
>>
> 
> .... but since the goal is to get apic_32.c and apic_64.c to be more
> converging (to the point of becoming the same file)... isn't your patch
> going in the opposite direction?
> 
Hmm, I'm not sure that this revert affects x86 unification.
Vivek said that probably we don't have to introduce lapic_shutdown() for 64bit.
So I submitted this patch which reverts my previous post, it was applied before
the comment.

Thanks
Hiroshi Shimamoto
