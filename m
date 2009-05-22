Return-Path: <linux-kernel-owner+w=401wt.eu-S1752241AbZEVFjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbZEVFjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 01:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbZEVFj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 01:39:27 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3027 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZEVFj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 01:39:26 -0400
Subject: Re: [PATCH V2 0/3] Introduce and use DO_ONCE statement expression
 macro
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Len Brown <len.brown@intel.com>,
       Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090522052652.GX8633@ZenIV.linux.org.uk>
References: <cover.1242965306.git.joe@perches.com>
	 <20090522052652.GX8633@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 21 May 2009 22:39:16 -0700
Message-Id: <1242970756.3284.18.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 06:26 +0100, Al Viro wrote:
> Your DO_ONCE(....) parses as "what the fuck is that?" followed by
> grepping for definition, and the cost is much higher.

So what do you suggest?

#define pr_info_once(fmt, args...)	printk_once(KERN_INFO pr_fmt(fmt), ##args)
#define pr_warning_once(fmt, args...)	printk_once(KERN_WARNING pr_fmt(fmt), ##args)
etc


