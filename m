Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYHRRWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYHRRWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYHRRWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:22:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46322 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYHRRWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:22:41 -0400
Message-ID: <48A9AFC4.8060505@zytor.com>
Date: Mon, 18 Aug 2008 10:22:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: mingo@elte.hu, macro@linux-mips.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/15] apic: unification series 5
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> With this series 32bit code compilation warns:
> 
> arch/x86/kernel/apic_32.c: In function ‘end_local_APIC_setup’:
> arch/x86/kernel/apic_32.c:1165: warning: ISO C90 forbids mixed declarations and code
> arch/x86/kernel/apic_32.c: In function ‘disconnect_bsp_APIC’:
> arch/x86/kernel/apic_32.c:1446: warning: ISO C90 forbids mixed declarations and code
> cyrill@lenovo linux-2.6.git $ 
> 
> So parenthesis will be needed to eliminate them... but
> I think it could be too ugly... need some time to think.
> So patches 8/15 and 10/15 sould be not applied for now - just review them.
> Thanks for patience!
> 

Typically, just move the declaration to the top of the function 
(followed by a blank line.)

	-hpa
