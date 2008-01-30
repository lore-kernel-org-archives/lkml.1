Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbYA3TM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbYA3TM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYA3TMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:12:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:46048 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbYA3TMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:12:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,279,1199692800"; 
   d="scan'208";a="255878707"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Date: Wed, 30 Jan 2008 11:10:51 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC757EAF@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080130184920.GA32212@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Thread-Index: AchjcRJ22WbMCkw7RHa9igpujVjjQQAAjLdw
References: <200801301414.m0UEEgCC006371@hera.kernel.org> <Pine.LNX.4.64.0801301622460.11859@vixen.sonytel.be> <47A09F8A.3000309@sgi.com> <20080130161036.GA12293@elte.hu> <1FE6DD409037234FAB833C420AA843EC757C72@orsmsx424.amr.corp.intel.com> <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <20080130184920.GA32212@elte.hu>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Mike Travis" <travis@sgi.com>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Linux/PPC Development" <linuxppc-dev@ozlabs.org>,
       <linux-ia64@vger.kernel.org>, <sparclinux@vger.kernel.org>
X-OriginalArrivalTime: 30 Jan 2008 19:10:51.0723 (UTC) FILETIME=[D47A41B0:01C86373]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> could you try the full patchset that Travis has just sent and which i've 
> put into x86.git, you can pull it from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
>
> it's a fixes only tree, ontop of Linus-very-latest. Head 4b9e425c25f84. 
> [pull from ssh://master.kernel.org if it's not on git.kernel.org yet, 
> uploaded it this very minute.]

Same build fail for CONFIG_SMP=n.  The SMP=y build is good (for tiger_defconfig)
and boots ok too.

-Tony
