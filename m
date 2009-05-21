Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbZEUXh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbZEUXh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 19:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZEUXhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 19:37:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52988 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZEUXhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 19:37:16 -0400
Message-ID: <4A15E589.2030003@zytor.com>
Date: Thu, 21 May 2009 16:36:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Ingo Molnar <mingo@redhat.com>,
       x86@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/3] kernel.h: Add DO_ONCE statement expression macro
References: <cover.1242943463.git.joe@perches.com>	 <7b063fda0675875d51a5da49f59e89520d025eee.1242943463.git.joe@perches.com>	 <4A15E36E.9080501@oracle.com> <1242948762.3373.143.camel@Joe-Laptop.home>
In-Reply-To: <1242948762.3373.143.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> 
> Add a DO_ONCE statement expression analogous to printk_once
> that executes any arbitrary statement exactly once.
> 

If you're truly going to make that guarantee you should use an atomic
test and set.

	-hpa
