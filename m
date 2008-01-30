Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbYA3UAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbYA3UAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYA3UAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:00:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:51902 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYA3UAf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:00:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,279,1199692800"; 
   d="scan'208";a="255884250"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Date: Wed, 30 Jan 2008 12:00:31 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC757F7C@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080130194616.GA19426@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Thread-Index: AchjeW+qgdyfWhf8R3SW1ot3jnLWpgAARA5A
References: <200801301414.m0UEEgCC006371@hera.kernel.org> <Pine.LNX.4.64.0801301622460.11859@vixen.sonytel.be> <47A09F8A.3000309@sgi.com> <20080130161036.GA12293@elte.hu> <1FE6DD409037234FAB833C420AA843EC757C72@orsmsx424.amr.corp.intel.com> <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <47A0CD4B.5040706@sgi.com> <1FE6DD409037234FAB833C420AA843EC757F12@orsmsx424.amr.corp.intel.com> <20080130194616.GA19426@elte.hu>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Mike Travis" <travis@sgi.com>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Linux/PPC Development" <linuxppc-dev@ozlabs.org>,
       <linux-ia64@vger.kernel.org>, <sparclinux@vger.kernel.org>
X-OriginalArrivalTime: 30 Jan 2008 20:00:31.0913 (UTC) FILETIME=[C4CF2990:01C8637A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ah, that was the vital clue. The patch below makes the small memory 
> model only defined on SMP, and makes the config build/link fine here. 
> Does this build and boot on your box?

I applied this on top of the git pull from
 git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

and I see see a build problem for SMP=n :-(

-Tony
