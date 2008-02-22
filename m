Return-Path: <linux-kernel-owner+w=401wt.eu-S1763848AbYBVC7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763848AbYBVC7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 21:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYBVC7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 21:59:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60364 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbYBVC7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 21:59:44 -0500
Message-ID: <47BE36B0.8070003@zytor.com>
Date: Thu, 21 Feb 2008 18:42:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Ian Campbell <ijc@hellion.org.uk>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86 : relocate uninitialized variable in init DATA
 section into init BSS section
References: <1203581723.4707.20.camel@caritas-dev.intel.com>	 <20080221090557.GB20055@elte.hu>	 <1203586106.4707.25.camel@caritas-dev.intel.com>	 <20080221095301.GA29361@elte.hu> <1203647880.4707.39.camel@caritas-dev.intel.com>
In-Reply-To: <1203647880.4707.39.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> 
> I think another method is to add a new attribute into GCC to prepend or
> append something to section name instead of just to replace it, like the
> example as follow:
> 
> #define __initdata  __attribute__((section_append(".init")))
> 

Same difference, but less flexible.

	-hpa
