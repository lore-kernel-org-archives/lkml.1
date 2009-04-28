Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbZD1Ww2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbZD1Ww2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZD1WwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:52:19 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:38379 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbZD1WwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:52:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18935.34966.533224.549662@cargo.ozlabs.ibm.com>
Date: Wed, 29 Apr 2009 08:52:06 +1000
From: Paul Mackerras <paulus@samba.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v2 12/15] powerpc: Use macros for .data.page_aligned section.
In-Reply-To: <1240938062-3264-13-git-send-email-tabbott@mit.edu>
References: <1240938062-3264-1-git-send-email-tabbott@mit.edu>
	<1240938062-3264-2-git-send-email-tabbott@mit.edu>
	<1240938062-3264-3-git-send-email-tabbott@mit.edu>
	<1240938062-3264-4-git-send-email-tabbott@mit.edu>
	<1240938062-3264-5-git-send-email-tabbott@mit.edu>
	<1240938062-3264-6-git-send-email-tabbott@mit.edu>
	<1240938062-3264-7-git-send-email-tabbott@mit.edu>
	<1240938062-3264-8-git-send-email-tabbott@mit.edu>
	<1240938062-3264-9-git-send-email-tabbott@mit.edu>
	<1240938062-3264-10-git-send-email-tabbott@mit.edu>
	<1240938062-3264-11-git-send-email-tabbott@mit.edu>
	<1240938062-3264-12-git-send-email-tabbott@mit.edu>
	<1240938062-3264-13-git-send-email-tabbott@mit.edu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott writes:

> diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
> index ad06d5c..841910a 100644
> --- a/arch/powerpc/kernel/vdso.c
> +++ b/arch/powerpc/kernel/vdso.c
> @@ -74,7 +74,7 @@ static int vdso_ready;
>  static union {
>  	struct vdso_data	data;
>  	u8			page[PAGE_SIZE];
> -} vdso_data_store __attribute__((__section__(".data.page_aligned")));
> +} vdso_data_store __page_aligned_data
                                        ^
Surely we need a semicolon here? -------|

Paul.
