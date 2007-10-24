Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbXJXGeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbXJXGeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbXJXGea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:34:30 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36469 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbXJXGe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:34:29 -0400
Date: Wed, 24 Oct 2007 12:04:34 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: hbabu@us.ibm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org
Subject: Re: [PATCH 0/3] x86: unify crash_32/64.c
Message-ID: <20071024063434.GC4622@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <47195763.1090803@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47195763.1090803@ct.jp.nec.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 06:18:27PM -0700, Hiroshi Shimamoto wrote:
> Hi,
> 
> I made patches to unify crash_32/64.c.
> There are three patches;
> 1. add lapic_shutdown for x86_64
> 2. add safe_smp_processor_id for x86_64
> 3. unify crash_32/64.c
> 
> I'm not sure that it's good to split to these patches.
> 
> I've compiled on both of 32bit and 64bit, and tested
> kdump on 64bit.
> 

Hi Hiroshi,

Thanks for the patches. Can you please also test it on 32bit to make
sure nothing is broken.

Thanks
Vivek
