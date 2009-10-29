Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZJ2QKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZJ2QKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbZJ2QKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:10:41 -0400
Received: from xenotime.net ([72.52.64.118]:42787 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753559AbZJ2QKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:10:40 -0400
Date: Thu, 29 Oct 2009 09:06:27 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: linux-next: Tree for October 29 (x86 posttest)
Message-Id: <20091029090627.7857ed08.rdunlap@xenotime.net>
In-Reply-To: <20091029182919.4d6ec52c.sfr@canb.auug.org.au>
References: <20091029182919.4d6ec52c.sfr@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 18:29:19 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> [I accidentally deleted my merge log today, so sorry to anyone who
> actually reads them :-), the summary still appears below.]


I'm getting this on x86_64:

  TEST    posttest
Error: ffffffff810299e2:	f2 41 0f 28 52 b0    	repnz movaps -0x50(%r10),%xmm2
Error: objdump says 6 bytes, but insn_get_length() says 4 (attr:0)
make[2]: *** [posttest] Error 2


any ideas?

thanks,
---
~Randy
