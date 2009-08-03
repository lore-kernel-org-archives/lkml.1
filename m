Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbZHCOW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbZHCOW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 10:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbZHCOWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 10:22:55 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:65141 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbZHCOWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 10:22:55 -0400
X-SourceIP: 213.93.53.227
Subject: Re: I.1 - System calls - ioctl
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: eranian@gmail.com, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <200907301920.52257.arnd@arndb.de>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <200907301840.50894.arnd@arndb.de>
	 <7c86c4470907300953g255c6088t7caaa1188be164e3@mail.gmail.com>
	 <200907301920.52257.arnd@arndb.de>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 16:22:38 +0200
Message-Id: <1249309358.7924.96.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 19:20 +0200, Arnd Bergmann wrote:
> On Thursday 30 July 2009, stephane eranian wrote:
> > But that won't always work in the case of a 32-bit monitoring tool
> > running on top of
> > a 64-bit OS. Imagine the target id is indeed 64-bit, e.g., inode
> > number (as suggested
> > by Peter). It's not because you are a 32-bit tool than you cannot name
> > a monitoring
> > resource in a 64-bit OS.
> 
> Right, there are obviously things that you cannot address with 
> a 'long', but there are potentially other things that you could
> that you cannot address with an 'int', e.g. an opaque user
> token (representing a user pointer) that you can get back in
> the sample data.
> 
> In the worst case, you could still redefine the argument as a
> transparent union to a long and pointer in the future if you
> use a 'long' now. AFAICT, there are no advantages of using
> an 'int' instead of a 'long', but there are disadvantages of
> using a 'long long'.

OK, so time is running out on this thing. Ingo, Paulus what would you
prefer?

