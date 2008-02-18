Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbYBRKzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbYBRKzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbYBRKzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:55:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59025 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830AbYBRKzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:55:07 -0500
Date: Mon, 18 Feb 2008 12:31:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Andi Kleen <andi@firstfloor.org>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] x86: validate against acpi motherboard resources
Message-ID: <20080218113107.GB24147@one.firstfloor.org>
References: <fa.LKjQjbOw482S/QFVaQ9fSrM+IFw@ifi.uio.no> <fa.wuwhrqFp6CufvpAJxShHqIaOPdI@ifi.uio.no> <47B67A0E.7060605@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B67A0E.7060605@shaw.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 11:52:14PM -0600, Robert Hancock wrote:
> Andi Kleen wrote:
> >Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
> >>[akpm@linux-foundation.org: many fixes and cleanups]
> >>Signed-off-by: Robert Hancock <hancockr@shaw.ca>
> >>Signed-off-by: Andi Kleen <ak@suse.de>
> >>Tested-by: Andi Kleen <ak@suse.de>
> >
> >iirc it really was 
> >Tested-and-didnt-pass-test-by: Andi Kleen 
> >unfortunately. I have not rechecked recently, but on the one Intel
> >box the original patch and the other mcfg heuristics removed didn't work.
> 
> With just this patch you will have this problem. You need either the 
> patch to disable decode during BAR sizing,

Isn't that one already merged?

I remember the BAR decoding patch did help with at least one
of the original failures (there were multiple ones iirc0) 

If someone points me to all the patches needed or a tree who 
has them all applied I can give it a quick spin on the boxes I have here.
One of the systems where it originally failed I don't have anymore
though.

> or the patch to use MMCONFIG 
> for extended config space only, if you don't have them already.

That would mean it would boot, but anything that uses extended config
space would fail. While not as catastrophic as before I'm not sure
it's that great either. At least there would be still breakage,
but much more subtle ones.

-Andi
