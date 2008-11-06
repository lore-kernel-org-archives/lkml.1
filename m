Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYKFG4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYKFG4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbYKFG4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:56:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45536 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYKFG4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:56:12 -0500
Message-ID: <4912943C.2090801@zytor.com>
Date: Wed, 05 Nov 2008 22:52:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH] x86: make NR_IRQS on 32bit is same to 64bit
References: <4910C845.4060909@kernel.org> <20081106062608.GC6384@elte.hu> <86802c440811052242taefec24ndf661b1c65ca457e@mail.gmail.com>
In-Reply-To: <86802c440811052242taefec24ndf661b1c65ca457e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>
>> Clean-up sidenote: i think we can now remove the VISWS #ifdef portion
>> for good? Mind sending a patch for that too?
> 
> could remove CONFIG_PARAVIRT too.. Jeremy?
> 

This seems like a bad idea, especially for the embedded guys.

	-hpa
