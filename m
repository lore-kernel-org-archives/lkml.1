Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbYHFW2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbYHFW2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYHFW2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:28:24 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:62284 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbYHFW2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:28:22 -0400
X-BigFish: VPS-33(zz1432R98dR936eQ1805Mzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <489A2627.40908@am.sony.com>
Date: Wed, 6 Aug 2008 15:31:03 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] bootup: Add built-in kernel command line for x86
References: <489A1844.3090502@am.sony.com> <1218060873.7576.2.camel@calx>
In-Reply-To: <1218060873.7576.2.camel@calx>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Aug 2008 22:28:07.0794 (UTC) FILETIME=[B3661D20:01C8F813]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Wed, 2008-08-06 at 14:31 -0700, Tim Bird wrote:
>> The default behavior is to append the boot loader string
>> to this one.  However, there is a mechanism (leading '!')
>> to force the built-in string to override the boot loader
>> string.
> 
> Nice solution.
> 
> Where is this relative to early boot option checking?

parse_early_param() is right AFTER this in the x86 setup_arch()
function (in arch/x86/kernel/setup.c).  All the other command-line
handling I could find is after this in init/main.c:start_kernel().

There is some stuff earlier in the setup_arch() routine about
boot_params, but that looks like it's related to the old(?)
binary data points you can jam into the kernel image.  (That is,
it doesn't look like it's related to the command line handling).
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

