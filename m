Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbYCLUwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbYCLUwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYCLUwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:52:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:41045 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbYCLUwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:52:36 -0400
Subject: Re: [BUG] 2.6.25-rc5-mm1 kernel panic with "Exception: 501 " on
	powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org
In-Reply-To: <20080312104645.34e58319.akpm@linux-foundation.org>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <47D7D2C9.4090001@linux.vnet.ibm.com>
	 <20080312104645.34e58319.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 07:40:06 +1100
Message-Id: <1205354406.9431.23.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Beats me.  Maybe we're still enabling interrupts too early.  But the new
> semaphore code got fixed (didn't it?)

Won't lockdep/irqtrace warn if that happens ? You don't yet have the
lockdep patches for ppc64 (I'm still trying to find out why they break
iSeries) but it should warn of such a spurrious IRQ enable on other
archs too... At least, from a quick look at the code, it -seems- that it
does have such a test.

Cheers,
Ben.


