Return-Path: <linux-kernel-owner+w=401wt.eu-S934281AbZLPAaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934281AbZLPAaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZLPAaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:30:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42737 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbZLPAaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:30:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC, PATCH 4/4] elf_core_dump(): Add extended numbering support
Cc: kosaki.motohiro@jp.fujitsu.com,
       Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jdike@addtoit.com, tony.luck@intel.com, mhiramat@redhat.com
In-Reply-To: <87k4wowcp9.fsf@basil.nowhere.org>
References: <20091215.114149.189724375.d.hatayama@jp.fujitsu.com> <87k4wowcp9.fsf@basil.nowhere.org>
Message-Id: <20091216092734.CDEE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 16 Dec 2009 09:30:09 +0900 (JST)
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

UML and ia64 have arch specific elf header. but real x86 don't.
then, we only need modify UML and ia64, because [4/4] introduce
new another header.



