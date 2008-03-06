Return-Path: <linux-kernel-owner+w=401wt.eu-S935489AbYCFUx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935489AbYCFUx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935314AbYCFUwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:52:53 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:53393 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935294AbYCFUww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:52:52 -0500
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Christoph Hellwig <hch@infradead.org>, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v3
References: <20080303230335.892214000@linux-os.sc.intel.com>
	<20080303230336.042604000@linux-os.sc.intel.com>
	<20080304012012.GB22431@infradead.org>
	<20080304014306.GC28006@linux-os.sc.intel.com>
	<20080304103220.GA17621@elte.hu>
	<20080304175528.GD28006@linux-os.sc.intel.com>
	<20080305194705.GA4386@ucw.cz> <20080306155141.GA23340@elte.hu>
	<20080306202446.GA4225@ucw.cz>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Mar 2008 21:52:48 +0100
In-Reply-To: <20080306202446.GA4225@ucw.cz>
Message-ID: <87r6enfucf.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Mar 2008 20:46:19.0515 (UTC) FILETIME=[2160F4B0:01C87FCB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:
> 
> Well, we should not be sending SIGSEGV...? SIGBUS would be cleaner, or
> SIGKILL... what happens when userland tries to catch this one?

When this happens the kernel is already in a severe out of memory
situation and no matter what you do user land will not be able
to handle this well.

-Andi
