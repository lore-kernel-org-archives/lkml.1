Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036Ab0ALK0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab0ALK0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 05:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000Ab0ALK0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 05:26:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36282 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753924Ab0ALK0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 05:26:51 -0500
Date: Tue, 12 Jan 2010 10:25:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR
 instead of 0x1f
Message-ID: <20100112102548.4de56c14@lxorguk.ukuu.org.uk>
In-Reply-To: <4B4BDBBA.3090406@zytor.com>
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>
	<4B47E7A9.6090904@zytor.com>
	<1263250418.2859.681.camel@sbs-t61.sc.intel.com>
	<4B4BACCA.2040805@zytor.com>
	<m1tyus8chc.fsf@fess.ebiederm.org>
	<4B4BB0B7.3000106@zytor.com>
	<1263254812.2859.890.camel@sbs-t61.sc.intel.com>
	<4B4BBEBA.4060403@zytor.com>
	<m17hro6ua9.fsf@fess.ebiederm.org>
	<4B4BC401.6010605@zytor.com>
	<m1k4vo144h.fsf@fess.ebiederm.org>
	<4B4BDBBA.3090406@zytor.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm wondering if what you're thinking of are the really old LAPICs which
> could only remember two pending interrupts per priority level?

On the really old boards an IPI can arrive more than once which makes
synchronization questions all the more interesting !

Alan
