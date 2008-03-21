Return-Path: <linux-kernel-owner+w=401wt.eu-S1762895AbYCUWxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895AbYCUWxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762741AbYCUWtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:49:25 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:56134 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762904AbYCUWtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:49:24 -0400
Date: Sat, 22 Mar 2008 00:49:18 +0200
From: Sami Farin <safari-kernel@safari.iki.fi>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
Message-ID: <20080321224918.scexlhjz3hv4sl7p@m.safari.iki.fi>
Mail-Followup-To: kernel list <linux-kernel@vger.kernel.org>
References: <200803202358.33722.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803202358.33722.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2008-03-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 23:58:33 -0700, Yinghai Lu wrote:
> 
> do simple memtest after init_memory_mapping
> 
> use find_e820_area_size to find all ram range that is not reserved.
> 
> and do some simple bits test to find some bad ram.
> 
> if find some bad ram, use reserve_early to exclude that range.

Does somebody still remember the bug report in which the fault
was found to be in hardware?  By bisecting, the user got "working"
kernel when movnti was not used to copy data.
Would be neat if also non-temporal moves were done in this early memtest.

Having the memtest feature in kernel is useful,
considering my grub can not load memtest86+ binary, failing with error
"Selected item cannot fit into memory",
with or without the patch at
https://bugzilla.redhat.com/show_bug.cgi?id=237279

I have user-space app to test movnti...  ask if you want it.

-- 
Do what you love because life is too short for anything else.

