Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbYHROjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbYHROjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYHROjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:39:18 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61870 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752903AbYHROjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:39:17 -0400
Date: Mon, 18 Aug 2008 15:38:09 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: David Fries <david@fries.net>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
In-Reply-To: <20080818125803.GC17528@spacedout.fries.net>
Message-ID: <Pine.LNX.4.55.0808181524460.29123@cliff.in.clinika.pl>
References: <20080818040340.GB17528@spacedout.fries.net>
 <Pine.LNX.4.55.0808180510480.26857@cliff.in.clinika.pl>
 <20080818125803.GC17528@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, David Fries wrote:

> That's what I get for reading the Intel instruction set reference,
> "The CR4 register was added to the Intel Architecture beginning with
> the Pentium processor."

 Indeed.  It started with the Pentium and some of the i486
models/steppings that were released after the Pentium got the CR4 register
implemented too.  These include at the least the write-back enhanced 
versions of the iDX2 and iDX4 processors as well later steppings of the 
i486SX, which I encountered myself.  There could be others -- iSX2?

 Unfortunately as usually with Intel you have to read all the documents
they release to hope to get a full image and even then you'll probably
come out confused and with bits of data missing -- if in doubt, check the
silicon: it has the most definite information.  However these additions
were actually documented quite well in the respective i486-class processor
datasheets -- IIRC Intel have released a combined version at one point.  
I am not sure whether it has ever been available on-line.

  Maciej
