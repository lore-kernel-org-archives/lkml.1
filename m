Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZF3OdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZF3OdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZF3Oc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:32:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45830 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbZF3Oc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:32:58 -0400
Message-ID: <4A4A21EB.9070708@zytor.com>
Date: Tue, 30 Jun 2009 07:32:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ix86: minor highmem related Kconfig cleanup
References: <4A4A0B2E02000078000082FE@vpn.id2.novell.com>
In-Reply-To: <4A4A0B2E02000078000082FE@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Remove a redundant conditional and consolidate a dependency.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
>  config HIGHPTE
>  	bool "Allocate 3rd-level pagetables from highmem"
> -	depends on X86_32 && (HIGHMEM4G || HIGHMEM64G)
> +	depends on HIGHMEM
>  	---help---
>  	  The VM uses one page table entry for each page of physical memory.
>  	  For systems with a lot of RAM, this can be wasteful of precious
> 

This is probably correct, but the "3rd-level" should have been removed
from the description long ago when this was made available to non-PAE
mode (if it ever wasn't.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

