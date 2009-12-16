Return-Path: <linux-kernel-owner+w=401wt.eu-S934595AbZLPCcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934595AbZLPCcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbZLPCcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:32:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48742 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbZLPCct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:32:49 -0500
Date: Wed, 16 Dec 2009 11:32:41 +0900 (JST)
Message-Id: <20091216.113241.189722720.d.hatayama@jp.fujitsu.com>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       tony.luck@intel.com, mhiramat@redhat.com
Subject: Re: [RFC, PATCH 4/4] elf_core_dump(): Add extended numbering
 support
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
In-Reply-To: <87k4wowcp9.fsf@basil.nowhere.org>
References: <20091215.114149.189724375.d.hatayama@jp.fujitsu.com>
	<87k4wowcp9.fsf@basil.nowhere.org>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com> writes:
> 
> > diff --git a/arch/um/sys-i386/elfcore.c b/arch/um/sys-i386/elfcore.c
> > index 4e320f0..4e34e47 100644
> > --- a/arch/um/sys-i386/elfcore.c
> > +++ b/arch/um/sys-i386/elfcore.c
> 
> Again you only seem to patch UML, not real x86 (arch/x86/*) ?
> 
> -Andi

Thanks for your comment.

ELF_CORE_EXTRA_* macros writes vDSO data, but currently it is included
in vmas part. See the commit f47aef55d9a18945fcdd7fd6bf01121ce973b91b.

On the other hand, for IA64 architecture, there is also unwiding
information, so the macros cannot be removed.

For UML-i386, I don't know wheather ELF_CORE_EXTRA_* can be removed or
not as i386 could.

Thanks.
