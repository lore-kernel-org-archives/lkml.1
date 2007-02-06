Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbXBFJaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbXBFJaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:30:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbXBFJaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:30:00 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:7785
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896AbXBFJaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:30:00 -0500
Message-Id: <45C85911.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Tue, 06 Feb 2007 09:31:45 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "Suresh B Siddha" <suresh.b.siddha@intel.com>,
       "Richard Gooch" <rgooch@safe-mbox.com>, <linux-kernel@vger.kernel.org>,
       <discuss@x86-64.org>
Subject: Re: [discuss] [patch] mtrr: fix issues with large addresses
References: <20070205171959.GF8665@alberich.amd.com>
 <20070205145055.A19581@unix-os.sc.intel.com>
 <200702060853.30812.ak@suse.de>
In-Reply-To: <200702060853.30812.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <ak@suse.de> 06.02.07 08:53 >>>
>On Monday 05 February 2007 23:50, Siddha, Suresh B wrote:
>> On Mon, Feb 05, 2007 at 06:19:59PM +0100, Andreas Herrmann wrote:
>> > o added check to restrict base address to 36 bit on i386
>> 
>> Why is this? It can go upto implemented physical bits, right?
>
>In theory it can, but Linux doesn't support it.

I don't think I remember a restriction here, at least not below 44 bits
(that's where pfn-s would need to become 64-bit wide).

Jan
