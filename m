Return-Path: <linux-kernel-owner+w=401wt.eu-S1423098AbXDXUxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423098AbXDXUxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423091AbXDXUxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:53:55 -0400
Received: from [63.81.120.158] ([63.81.120.158]:61460 "EHLO
	gateway-1237.mvista.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1423098AbXDXUxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:53:54 -0400
Subject: Re: [patch 1/4] Ignore stolen time in the softlockup watchdog
From: Daniel Walker <dwalker@mvista.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Prarit Bhargava <prarit@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>, john stultz <johnstul@us.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, virtualization@lists.osdl.org,
       Chris Lalancette <clalance@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <462E6778.7070305@goop.org>
References: <20070327214919.800272641@goop.org>
	 <20070327215827.871954359@goop.org>
	 <20070423234910.50149faf.akpm@linux-foundation.org>
	 <462E43A7.1050001@goop.org>
	 <20070424105738.e0ce36a9.akpm@linux-foundation.org>
	 <462E4969.6070802@goop.org>
	 <20070424113222.ed2e1314.akpm@linux-foundation.org>
	 <462E61F1.7060403@goop.org>  <462E6778.7070305@goop.org>
Content-Type: text/plain
Date: Tue, 24 Apr 2007 13:52:27 -0700
Message-Id: <1177447948.12796.66.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-24 at 13:24 -0700, Jeremy Fitzhardinge wrote:

> And sched_clock's use of local_irq_save/restore appears to be absolutely
> correct, so I think it must be triggering a bug in either the self-tests
> or lockdep itself.

Why does sched_clock need to disable interrupts?

Daniel

