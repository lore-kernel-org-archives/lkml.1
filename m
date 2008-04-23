Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbYDWX3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbYDWX3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 19:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYDWX3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 19:29:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39913 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752810AbYDWX3i (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 19:29:38 -0400
Date: Thu, 24 Apr 2008 09:29:00 +1000
From: David Chinner <dgc@sgi.com>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Adrian Bunk <bunk@kernel.org>, Willy Tarreau <w@1wt.eu>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080423232900.GS103491721@sgi.com>
References: <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <20080420132113.GA1899@cs181133002.pp.htv.fi> <480EFDD3.4020707@aitel.hist.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480EFDD3.4020707@aitel.hist.no>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 11:13:55AM +0200, Helge Hafting wrote:
> Adrian Bunk wrote:
> >What actually brings bad reputation is shipping a 4k option that is 
> >known to break under some circumstances.
> >  
> How about making 4k stacks incompatible with those circumstances then?
> I.e. is you select 4k stacks, then you can't select XFS because we know
> that _may_ fail. Similiar for ndiswrapper networking, and other
> stuff where problems have been noticed.

Yeah, that means every distro that supports XFS (i.e. pretty much
all of them including Fedora) will be forced disable 4k stacks on
x86.  I'd be happy with this solution.

FWIW, this would make 4k stacks pretty much unused outside of custom
kernels.  At which point I'd suggest a default of 4k is wrong....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
