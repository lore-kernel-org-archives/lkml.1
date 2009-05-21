Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZEUXwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZEUXwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 19:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZEUXwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 19:52:34 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2661 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZEUXwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 19:52:34 -0400
Subject: Re: [PATCH 2/3] arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: Use
 DO_ONCE & spelling fix
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, x86@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <20090521234726.GA24695@redhat.com>
References: <cover.1242943463.git.joe@perches.com>
	 <a4b6b12afa9cf1ee6e936de5eed7cb31181553d8.1242943463.git.joe@perches.com>
	 <20090521232604.GA26150@redhat.com>
	 <1242948841.3373.145.camel@Joe-Laptop.home>
	 <20090521234726.GA24695@redhat.com>
Content-Type: text/plain
Date: Thu, 21 May 2009 16:52:19 -0700
Message-Id: <1242949939.3373.149.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 19:47 -0400, Dave Jones wrote:
> I just think it's a less readable variant of the same thing.
> The shouty macro, the extra level of brackets, the whole thing 
> just seems to be ugly to me with no redeeming feature.
> 
> What does doing this change really bring us?

The ability to use pr_<foo> types rather than printk_once(KERN_<foo>
and have the pr_fmt macro function correctly.

DO_ONCE(pr_info(

vs

printk_once(KERN_INFO


