Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYGMBC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYGMBC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 21:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYGMBCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 21:02:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:58979 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYGMBCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 21:02:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,352,1212390000"; 
   d="scan'208";a="414389383"
Date: Sat, 12 Jul 2008 18:02:48 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
Message-ID: <20080713010247.GC1678@linux-os.sc.intel.com>
References: <20080711204521.GA15689@elte.hu> <20080711212418.GV1678@linux-os.sc.intel.com> <86802c440807111502n9835b5fybd99ed388bb71b7d@mail.gmail.com> <86802c440807112016k38c8161aq143463ee57b24c35@mail.gmail.com> <m163rb4v3j.fsf@frodo.ebiederm.org> <86802c440807112317h23118e29j51113a052720d8db@mail.gmail.com> <m1y7471t5t.fsf@frodo.ebiederm.org> <86802c440807120049t2aaec131l4c735712f2befb2@mail.gmail.com> <m1tzev1pyy.fsf@frodo.ebiederm.org> <86802c440807120137l186864a3s5046ecbee6c63531@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807120137l186864a3s5046ecbee6c63531@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 01:37:01AM -0700, Yinghai Lu wrote:
> is it like
> 0x0001, 0x0002, 0x0004, 0x0008, ...., 0x8000 in one cluster? so every
> cluster only have 16

for logical cluster id's, yes.
