Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZBCROr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZBCROr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZBCROg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:14:36 -0500
Received: from gw.goop.org ([64.81.55.164]:37226 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbZBCROg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:14:36 -0500
Message-ID: <49887B79.4040708@goop.org>
Date: Tue, 03 Feb 2009 09:14:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: fix 32-bit build resulting from mmu move
References: <49876C6E.3010809@goop.org> <20090203122112.GD19979@elte.hu>
In-Reply-To: <20090203122112.GD19979@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Moving the mmu code from enlighten.c to mmu.c inadvertently broke the
>> 32-bit build.  Fix it.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> ---
>> arch/x86/xen/mmu.c |   37 +++++++++++++++++++++++++++++++++++++
>> 1 file changed, 37 insertions(+)
>>     
>
> that goes on top of the recent tip/x86/paravirt changes, right? No 
> objections, i'm wondering why my testing didnt find any build breakage. 
> Could you send me a .config that triggers the breakage?
>   

Any x86-32 + Xen build would hit it. +highmem+highpte would break a bit 
more.

    J
