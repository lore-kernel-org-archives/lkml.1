Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZJULxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZJULxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 07:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZJULxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 07:53:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbZJULxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 07:53:48 -0400
Date: Wed, 21 Oct 2009 13:52:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Thomas Schlichter <thomas.schlichter@web.de>,
       Jan Beulich <JBeulich@novell.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       "hancockrwd@gmail.com" <hancockrwd@gmail.com>,
       "hmh@hmh.eng.br" <hmh@hmh.eng.br>, "hpa@zytor.com" <hpa@zytor.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "thellstrom@vmware.com" <thellstrom@vmware.com>,
       "tj@kernel.org" <tj@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "yinghai@kernel.org" <yinghai@kernel.org>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
	available
Message-ID: <20091021115259.GE16586@elte.hu>
References: <1392906098@web.de> <20091019153134.GA18198@elte.hu> <200910202235.12277.thomas.schlichter@web.de> <1256075963.2685.7.camel@sbs-t61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256075963.2685.7.camel@sbs-t61>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Tue, 2009-10-20 at 13:35 -0700, Thomas Schlichter wrote:
> > What do you think about the latest version of my patch series I just sent?
> 
> I think we can simplify this by just using mtrr_add_page() and avoid 
> all the complexity that comes with mtrr_add_unaligned().
> 
> pci_mmap_range() should call one mtrr_add_page() if the base and size 
> are nicely aligned. Almost all the cases, this is the usage sequence 
> here anyway.

yep, keeping it simple is a must.

	Ingo
