Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZEYIZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZEYIZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbZEYIZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:25:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZEYIZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:25:06 -0400
Subject: Re: [Bug #13331] FUTEX_LOCK_PI kills kernel
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andreas Schwab <schwab@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <uSztiUhmDDC.A.0_H.h9bGKB@chimera>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
	 <uSztiUhmDDC.A.0_H.h9bGKB@chimera>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 25 May 2009 10:24:56 +0200
Message-Id: <1243239896.26820.648.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-24 at 21:11 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13331
> Subject		: FUTEX_LOCK_PI kills kernel
> Submitter	: Andreas Schwab <schwab@linux-m68k.org>
> Date		: 2009-05-17 09:51 (8 days old)

commit 64d1304a64477629cb16b75491a77bafe6f86963
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon May 18 21:20:10 2009 +0200

    futex: setup writeable mapping for futex ops which modify user space data


