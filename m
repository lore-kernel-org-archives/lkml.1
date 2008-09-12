Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYILWhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYILWhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbYILWhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:37:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47228
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754891AbYILWhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:37:09 -0400
Date: Fri, 12 Sep 2008 15:37:03 -0700 (PDT)
Message-Id: <20080912.153703.21849753.davem@davemloft.net>
To: roland@redhat.com
Cc: rmk+lkml@arm.linux.org.uk, linux-arch@vger.kernel.org,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HAVE_ARCH_TRACEHOOK and you
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080912223156.51D4815420D@magilla.localdomain>
References: <20080912025733.E55F415420D@magilla.localdomain>
	<20080912131351.GA31545@flint.arm.linux.org.uk>
	<20080912223156.51D4815420D@magilla.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>
Date: Fri, 12 Sep 2008 15:31:56 -0700 (PDT)

> > means sparc ends up allocating 38 * sizeof(u32) * sizeof(u32), and
> > sparc64 ends up with 36 * sizeof(u64) * sizeof(u64), which must surely
> > be wrong?
> 
> Yup!  Sure looks like Dave skipped the step where it says "test that core
> dumps work ... and produce correct results". :-)

It was allocating too much memory, which is harmless.

So it did work, and I did test it.
