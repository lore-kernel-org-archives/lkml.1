Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbZKFQ7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbZKFQ7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 11:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759298AbZKFQ7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 11:59:53 -0500
Received: from xenotime.net ([72.52.64.118]:46812 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757834AbZKFQ7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 11:59:52 -0500
Date: Fri, 6 Nov 2009 08:59:54 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 29 (x86 posttest)
Message-Id: <20091106085954.39eb2789.rdunlap@xenotime.net>
In-Reply-To: <4AE9C74C.2040309@redhat.com>
References: <20091029182919.4d6ec52c.sfr@canb.auug.org.au>
	<20091029090627.7857ed08.rdunlap@xenotime.net>
	<4AE9C74C.2040309@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 12:48:12 -0400 Masami Hiramatsu wrote:

> Randy Dunlap wrote:
> > On Thu, 29 Oct 2009 18:29:19 +1100 Stephen Rothwell wrote:
> >
> >> Hi all,
> >>
> >> [I accidentally deleted my merge log today, so sorry to anyone who
> >> actually reads them :-), the summary still appears below.]
> >
> >
> > I'm getting this on x86_64:
> >
> >    TEST    posttest
> > Error: ffffffff810299e2:	f2 41 0f 28 52 b0    	repnz movaps -0x50(%r10),%xmm2
> > Error: objdump says 6 bytes, but insn_get_length() says 4 (attr:0)
> > make[2]: *** [posttest] Error 2
> 
> Ah, that's should be fixed by AVX support patch which I've posted.
> http://git.kernel.org/tip/e0e492e99b372c6990a5daca9e4683c341f1330e

Has that been merged into linux-next?
I'm still seeing this failure in linux-next-20091106.


---
~Randy
