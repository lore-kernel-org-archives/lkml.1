Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbYANQG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbYANQG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYANQGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:06:22 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:31089
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbYANQGV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:06:21 -0500
Message-Id: <478B96A5.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 14 Jan 2008 16:06:45 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>,
       "Jeremy Fitzhardinge" <jeremy@xensource.com>
Subject: Re: [PATCH] adjust/fix LDT handling for Xen
References: <4787436E.76E4.0078.0@novell.com>
 <20080114154817.GA14000@elte.hu>
In-Reply-To: <20080114154817.GA14000@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 14.01.08 16:48 >>>
>
>* Jan Beulich <jbeulich@novell.com> wrote:
>
>> Don't rely on kmalloc(PAGE_SIZE) returning PAGE_SIZE aligned memory 
>> (Xen requires GDT *and* LDT to be page-aligned). Using the page 
>> allocator interface also removes the (albeit small) slab allocator 
>> overhead. The same change being done for 64-bits for consistency.
>> 
>> Further, the Xen hypercall interface expects the LDT address to be 
>> virtual, not machine.
>
>coul dyou try this against x86.git as well? We already unified ldt.c as 
>part of the paravirt patches.

Sure, but it may take me a little while.

Jan

