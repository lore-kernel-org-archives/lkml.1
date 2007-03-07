Return-Path: <linux-kernel-owner+w=401wt.eu-S965563AbXCGTXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965563AbXCGTXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965586AbXCGTXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:23:54 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33095 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965563AbXCGTXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:23:53 -0500
Date: Wed, 7 Mar 2007 20:24:04 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       pavel@suse.cz, rjw@sisk.pl
Subject: Re: [PATCH 1/20] x86_64: Assembly safe page.h and pgtable.h
Message-ID: <20070307192404.GA31826@uranus.ravnborg.org>
References: <20070307065703.GA23412@in.ibm.com> <20070307065920.GB23412@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307065920.GB23412@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 12:29:20PM +0530, Vivek Goyal wrote:
> 
> 
> This patch makes pgtable.h and page.h safe to include
> in assembly files like head.S.  Allowing us to use
> symbolic constants instead of hard coded numbers when
> refering to the page tables.
> 
> This patch copies asm-sparc64/const.h to asm-x86_64 to
> get a definition of _AC() a very convinient macro that
> allows us to force the type when we are compiling the
> code in C and to drop all of the type information when
> we are using the constant in assembly.
Should this file not live in asm-generic and be useable
for all architectures?

	Sam
