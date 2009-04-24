Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbZDXAWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbZDXAWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 20:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZDXAWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 20:22:10 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:40442 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZDXAWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 20:22:08 -0400
Date: Fri, 24 Apr 2009 09:16:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Am??rico Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v3 1/3] Make section names compatible with -ffunction-sections -fdata-sections
Message-ID: <20090424001658.GB27897@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tim Abbott <tabbott@MIT.EDU>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
	Denys Vlasenko <vda.linux@googlemail.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Jeff Arnold <jbarnold@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jon Masters <jonathan@jonmasters.org>,
	Masami Hiramatsu <mhiramat@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Nikanth Karthikesan <knikanth@suse.de>,
	Arjan van de Ven <arjan@infradead.org>,
	Am??rico Wang <xiyou.wangcong@gmail.com>
References: <alpine.DEB.1.10.0904221826180.24694@vinegar-pot.mit.edu> <1240519774-20307-1-git-send-email-tabbott@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240519774-20307-1-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 04:49:32PM -0400, Tim Abbott wrote:
> The purpose of this patch is to make it possible to build the kernel
> with "gcc -ffunction-sections -fdata-sections".  This is a key step
> towards being able to compile the kernel using the --gc-sections
> linker option, which can be used to decrease the vmlinux size by
> garbage collecting unused functions.  Also, Ksplice's 'run-pre
> matching' process is much simpler if the original kernel was compiled
> with -ffunction-sections and -fdata-sections.
> 
[snip]

> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Signed-off-by: Anders Kaseorg <andersk@mit.edu>

As this is the only really invasive part of the patch, it would certainly
be good to see this merged early.

Acked-by: Paul Mundt <lethal@linux-sh.org>
