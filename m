Return-Path: <linux-kernel-owner+w=401wt.eu-S1760022AbZAIWjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbZAIWjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZAIWjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:39:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34653 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbZAIWjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:39:14 -0500
Message-ID: <4967D223.1090703@zytor.com>
Date: Fri, 09 Jan 2009 14:39:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@elte.hu, tglx@linutronix.de, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, tvignaud@mandriva.com
Subject: Re: [patch] x86, pat: fix reserve_memtype() for legacy 1MB range
References: <20090109223520.GC6472@linux-os.sc.intel.com>
In-Reply-To: <20090109223520.GC6472@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> 
> Here X is trying to map first 8KB of memory using /dev/mem. Existing
> code treats first 0-4KB of memory as non-RAM and 4KB-8KB as RAM. Recent
> code changes don't allow to map memory with different attributes
> at the same time.
> 

Why was 0-4 KB marked as non-RAM?  It is most definitely RAM, and should 
be WB.

	-hpa
