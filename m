Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbZEVHBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbZEVHBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 03:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZEVHBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 03:01:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43510 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZEVHBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 03:01:11 -0400
Date: Fri, 22 May 2009 08:01:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Len Brown <len.brown@intel.com>,
       Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH V2 0/3] Introduce and use DO_ONCE statement expression
	macro
Message-ID: <20090522070111.GZ8633@ZenIV.linux.org.uk>
References: <cover.1242965306.git.joe@perches.com> <20090522052652.GX8633@ZenIV.linux.org.uk> <1242970756.3284.18.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242970756.3284.18.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 10:39:16PM -0700, Joe Perches wrote:
> On Fri, 2009-05-22 at 06:26 +0100, Al Viro wrote:
> > Your DO_ONCE(....) parses as "what the fuck is that?" followed by
> > grepping for definition, and the cost is much higher.
> 
> So what do you suggest?
> 
> #define pr_info_once(fmt, args...)	printk_once(KERN_INFO pr_fmt(fmt), ##args)
> #define pr_warning_once(fmt, args...)	printk_once(KERN_WARNING pr_fmt(fmt), ##args)
> etc

That would be much saner.
