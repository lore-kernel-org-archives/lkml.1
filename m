Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbXDUWzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbXDUWzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 18:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbXDUWzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 18:55:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:29657 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbXDUWzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 18:55:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YzBOEo1bw65y9HIgEDIsva/QzeTctR4jGCXIXAcOEJJL7tOvf/duWZiUyT/2ESKdlx3BulhS7PmQJHH+BkLEpTlevfRY0BHlW+MNFmRX/A5azwMttU/kUbF5QQhBbkaYEeJOcYDSJTxyW6mnb0wxl21+ACo6WMUWyKd9MsBWNV8=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Sun, 22 Apr 2007 00:54:58 +0200
User-Agent: KMail/1.8.2
Cc: Con Kolivas <kernel@kolivas.org>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu>
In-Reply-To: <20070421160008.GA28783@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704220054.58639.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2007 18:00, Ingo Molnar wrote:
> correct. Note that Willy reniced X back to 0 so it had no relevance on 
> his test. Also note that i pointed this change out in the -v4 CFS 
> announcement:
> 
> || Changes since -v3:
> ||
> ||  - usability fix: automatic renicing of kernel threads such as 
> ||    keventd, OOM tasks and tasks doing privileged hardware access
> ||    (such as Xorg).
> 
> i've attached it below in a standalone form, feel free to put it into 
> SD! :)

But X problems have nothing to do with "privileged hardware access".
X problems are related to priority inversions between server and client
processes, and "one server process - many client processes" case.

I think syncronous nature of Xlib (clients cannot fire-and-forget
their commands to X server, with Xlib each command waits for ACK
from server) also add some amount of pain.
--
vda
