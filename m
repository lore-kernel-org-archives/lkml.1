Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890Ab0AWB0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab0AWB0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 20:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759Ab0AWB0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 20:26:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753998Ab0AWB0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 20:26:21 -0500
Date: Fri, 22 Jan 2010 17:26:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <teawater@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       Ozan =?ISO-8859-1?Q?=C7aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add options to markup_oops.pl to make it support 
 cross-compiler environment better
Message-Id: <20100122172615.4a560908.akpm@linux-foundation.org>
In-Reply-To: <daef60381001170538o5b3b0b17l72923261b76d521@mail.gmail.com>
References: <daef60381001170538o5b3b0b17l72923261b76d521@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jan 2010 21:38:28 +0800
Hui Zhu <teawater@gmail.com> wrote:

> Hello,
> 
> The markup_oops.pl have 2 troubles to support cross-compiler environment:
> 1.  It use objdump directly.
> 2.  It use modinfo to get the message of module.
> 
> This patch add 2 options to markup_oops.pl:
> 1. -c CROSS_COMPILE	Specify the prefix used for toolchain.
> 2. -m MODULE_DIRNAME	Specify the module directory name.
> 
> After this patch, parse the x8664 oops in x86, we can:
> cat amd64m | perl ~/kernel/tmp/m.pl -c
> /home/teawater/kernel/bin/x8664- -m ./e.ko vmlinux
> 

The other patches are wordwrapped and one still didn't apply after
fixing that, so please just redo and resend everything.  Send them to
yourself first and check that the result still applies OK.


Also, we prefer patch titles to be of the form

	subsystem-identifier: what was changed

so a good title for this patch would have been

	markup_oops.pl: add options to improve cross-sompilation environments


Thanks.
