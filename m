Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbXFLI0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbXFLI0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 04:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbXFLI0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 04:26:13 -0400
Received: from www.osadl.org ([213.239.205.134]:60396 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751983AbXFLI0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 04:26:12 -0400
Subject: Re: [stable] [PATCH] ACPI: Move timer broadcast and pmtimer access
	before C3 arbiter shutdown
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>, Stable Team <stable@kernel.org>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <20070612010735.GL3723@sequoia.sous-sol.org>
References: <1181122673.4404.200.camel@chaos>
	 <20070606183857.caa243d4.akpm@linux-foundation.org>
	 <20070612010735.GL3723@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 10:26:07 +0200
Message-Id: <1181636767.8176.199.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-11 at 18:07 -0700, Chris Wright wrote:
> * Andrew Morton (akpm@linux-foundation.org) wrote:
> > hm, this needs a bit of help to get it to work against Len's current tree.
> 
> Here's some help, compile tested only.  Udo/Thomas, was this found to
> be root cause of a real bug?  I didn't want this to get lost if it's
> still meant to be relevant for -stable.

Chris,

I fixed this against -mm already. I don't think that it is relevant for
stable. The issue was found with Venkis hpet force enable patches on a
ICH4 system. I doubt that any of those systems has hpet enabled in the
BIOS. It should not affect later ICH chip sets. Venki, is this correct ?

	tglx


