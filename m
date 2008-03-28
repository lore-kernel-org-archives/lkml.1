Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbYC1Qp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbYC1Qp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbYC1QpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:45:16 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43879 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbYC1QpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:45:15 -0400
Subject: Re: [PATCH 3 of 4] sparsemem: reduce i386 PAE section size
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <b7d0773c79887ca98d6c.1206664119@localhost>
References: <b7d0773c79887ca98d6c.1206664119@localhost>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 09:45:08 -0700
Message-Id: <1206722708.7883.122.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 17:28 -0700, Jeremy Fitzhardinge wrote:
> diff --git a/include/asm-x86/sparsemem.h b/include/asm-x86/sparsemem.h
> --- a/include/asm-x86/sparsemem.h
> +++ b/include/asm-x86/sparsemem.h
> @@ -16,7 +16,7 @@
> 
>  #ifdef CONFIG_X86_32
>  # ifdef CONFIG_X86_PAE
> -#  define SECTION_SIZE_BITS    30
> +#  define SECTION_SIZE_BITS    29
>  #  define MAX_PHYSADDR_BITS    36
>  #  define MAX_PHYSMEM_BITS     36
>  # else

This is fine with me as long as we have the room in page->flags.  I
probably need to look at Christoph's new patches, too.

-- Dave

