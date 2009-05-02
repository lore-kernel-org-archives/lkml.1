Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbZEBOUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbZEBOUQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 10:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbZEBOT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 10:19:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41237 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbZEBOT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 10:19:58 -0400
Date: Sat, 2 May 2009 10:19:53 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
Subject: Re: [PATCH 0/5] section name cleanup for parisc
Message-ID: <20090502141953.GC28342@bombadil.infradead.org>
References: <1241135719-9286-1-git-send-email-tabbott@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241135719-9286-1-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 07:55:14PM -0400, Tim Abbott wrote:
> This patch series cleans up the section names on the parisc
> architecture.  It requires the architecture-independent macro
> definitions from this patch series:
> 
> <http://www.spinics.net/lists/mips/msg33499.html>
> 
> The long-term goal here is to add support for building the kernel with
> -ffunction-sections -fdata-sections.  This requires renaming all the
> magic section names in the kernel of the form .text.foo, .data.foo,
> .bss.foo, and .rodata.foo to not have collisions with sections
> generated for code like:
> 
> static int nosave = 0; /* -fdata-sections places in .data.nosave */
> static void head(); /* -ffunction-sections places in .text.head */
> 
> Note that these patches have not been boot-tested (aside from testing
> the analogous changes on x86), since I don't have access to the
> appropriate hardware.
> 
> 	-Tim Abbott
> 
> 
> Tim Abbott (5):
>   parisc: use NOSAVE_DATA macro for .data.nosave section.
>   parisc: use new macro for .data.cacheline_aligned section.
>   parisc: use new macros for .data.init_task.
>   parisc: use new macro for .data.read_mostly section.
>   parisc: convert to new generic read_mostly support.
> 

Not sure what the easiest way to merge these will be... I'll apply them
to a section-cleanup branch in the parisc git tree until the
architecture independent portions are upstream.

regards, Kyle
