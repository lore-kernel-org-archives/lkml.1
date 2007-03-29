Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbXC2Nsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbXC2Nsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 09:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXC2Nsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 09:48:42 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:54095
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499AbXC2Nsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 09:48:41 -0400
Message-Id: <460BDFF9.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Thu, 29 Mar 2007 14:49:13 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [PATCH] x86: tighten kernel image page access rights
	(re-diff against firstfloor tree)
References: <460BC6A7.76E4.0078.0@novell.com>
 <200703291422.33537.ak@suse.de>
In-Reply-To: <200703291422.33537.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <ak@suse.de> 29.03.07 14:22 >>>
>On Thursday 29 March 2007 14:01, Jan Beulich wrote:
>> On x86-64, kernel memory freed after init can be entirely unmapped instead
>> of just getting 'poisoned' by overwriting with a debug pattern.
>> 
>> On i386 and x86-64 (under CONFIG_DEBUG_RODATA), kernel text and bug table
>> can also be write-protected.
>> 
>> (Not sure what the symbol 'stext' is good for; can it be removed?)
>
>I see you remove it already

I don't think I do - I just move _stext (on x86-64), but leave stext alone.

Jan
