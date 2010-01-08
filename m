Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412Ab0AHB0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab0AHB0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 20:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482Ab0AHB0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 20:26:52 -0500
Received: from mx2.netapp.com ([216.240.18.37]:5445 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab0AHB0v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 20:26:51 -0500
X-IronPort-AV: E=Sophos;i="4.49,238,1262592000"; 
   d="scan'208";a="298904142"
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1262913752.2659.100.camel@localhost>
References: <1262896174.2659.3.camel@localhost>
	 <87zl4pmxzp.fsf@basil.nowhere.org> <1262901198.2659.38.camel@localhost>
	 <20100107235149.GD16076@basil.fritz.box>
	 <1262909682.2659.45.camel@localhost>
	 <alpine.LFD.2.00.1001071633200.7821@localhost.localdomain>
	 <1262912601.2659.89.camel@localhost>
	 <alpine.LFD.2.00.1001071707430.7821@localhost.localdomain>
	 <1262913752.2659.100.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Thu, 07 Jan 2010 20:26:14 -0500
Message-ID: <1262913974.2659.101.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
X-OriginalArrivalTime: 08 Jan 2010 01:26:39.0220 (UTC) FILETIME=[A04C4340:01CA9001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 20:22 -0500, Trond Myklebust wrote: 
> All I want to ensure is that people who use non-posix-lock based
> synchronisation can set the 'noac' flag, and be assured that if mmap()
> is called _after_ they have grabbed their lock, then the page cache will
> be duly revalidated (under the lock), and the fresh data will be made
> available.

BTW: This is the same guarantee that we offer in the case of standard
read() (and write()) when 'noac' is set.
