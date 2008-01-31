Return-Path: <linux-kernel-owner+w=401wt.eu-S1765665AbYAaHmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765665AbYAaHmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYAaHlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:41:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:33948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765430AbYAaHlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:41:51 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 2/5] x86: c_p_a clflush_cache_range fix
Date: Thu, 31 Jan 2008 08:40:25 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <1201764962.12950.23.camel@caritas-dev.intel.com>
In-Reply-To: <1201764962.12950.23.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801310840.25221.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2008 08:36:02 Huang, Ying wrote:
> Because in i386 early boot stage, boot_cpu_data may be not available,
> which makes clflush_cach_range() into infinite loop, which is called
> by change_page_attr(). This patch fixes this by providing a default
> clflush_size of 64. But the better method may be providing a
> early_identify_cpu() for i386.

There already is one. arch/x86/kernel/cpu/common.c:early_cpu_detect 
Just set it to 64 there.

-Andi

