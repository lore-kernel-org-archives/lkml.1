Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYHFWu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYHFWu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbYHFWur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:50:47 -0400
Received: from waste.org ([66.93.16.53]:42072 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbYHFWuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:50:46 -0400
Subject: Re: [PATCH] bootup: Add built-in kernel command line for x86
From: Matt Mackall <mpm@selenic.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <489A2627.40908@am.sony.com>
References: <489A1844.3090502@am.sony.com> <1218060873.7576.2.camel@calx>
	 <489A2627.40908@am.sony.com>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 17:48:51 -0500
Message-Id: <1218062931.7576.12.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-08-06 at 15:31 -0700, Tim Bird wrote:
> Matt Mackall wrote:
> > On Wed, 2008-08-06 at 14:31 -0700, Tim Bird wrote:
> >> The default behavior is to append the boot loader string
> >> to this one.  However, there is a mechanism (leading '!')
> >> to force the built-in string to override the boot loader
> >> string.
> > 
> > Nice solution.
> > 
> > Where is this relative to early boot option checking?
> 
> parse_early_param() is right AFTER this in the x86 setup_arch()
> function (in arch/x86/kernel/setup.c).  All the other command-line
> handling I could find is after this in init/main.c:start_kernel().

Ok, there are a couple weird outliers outside of that still, but that
should make most people satisfied.

-- 
Mathematics is the supreme nostalgia of our time.

