Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbZJSPKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbZJSPKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbZJSPKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:10:21 -0400
Received: from fmmailgate06.web.de ([217.72.192.247]:35404 "EHLO
	fmmailgate06.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442AbZJSPKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:10:20 -0400
Date: Mon, 19 Oct 2009 17:10:24 +0200
Message-Id: <1392925495@web.de>
MIME-Version: 1.0
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>
Cc: JBeulich@novell.com, arjan@linux.intel.com,
       dri-devel@lists.sourceforge.net, hancockrwd@gmail.com, hmh@hmh.eng.br,
       hpa@zytor.com, jbarnes@virtuousgeek.org, jeremy.fitzhardinge@citrix.com,
       linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
       thellstrom@vmware.com, tj@kernel.org, venkatesh.pallipadi@intel.com,
       x86@kernel.org, yinghai@kernel.org
Subject: =?iso-8859-15?Q?Re:_[RFC_Patch]_use_MTRR_for_write_combining_if_PAT_is?=
 =?iso-8859-15?Q?_not_available?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+Z1yr4qmU8yBMjybr87HoZGYkP0Fc+SNtMC/CGcFfA+CJc8
 oL0fq0c4QwEKxB8dLK7MJvvk151qaTTaae1tNXUI+mOCg1RvUmUU8sShLxCK
 g==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > Can't we just force PAT option always and we probably don't care about 
> > ioremap_wc() on processors were PAT doesn't get enabled because of 
> > known errata.
> 
> We can make PAT configurability dependent on EMBEDDED-y - mind sending a 
> patch for that?

I think there already is such a patch in -tip:
http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commitdiff;h=c03cb3149daed3e411657e3212d05ae27cf1a874

Kind regards,
  Thomas
