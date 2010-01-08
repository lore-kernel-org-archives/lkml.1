Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571Ab0AHBEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab0AHBEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 20:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179Ab0AHBEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 20:04:38 -0500
Received: from mx2.netapp.com ([216.240.18.37]:49739 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab0AHBEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 20:04:37 -0500
X-IronPort-AV: E=Sophos;i="4.49,238,1262592000"; 
   d="scan'208";a="298899069"
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100108004513.GF16076@basil.fritz.box>
References: <1262896174.2659.3.camel@localhost>
	 <87zl4pmxzp.fsf@basil.nowhere.org> <1262901198.2659.38.camel@localhost>
	 <20100107235149.GD16076@basil.fritz.box>
	 <1262909682.2659.45.camel@localhost>
	 <alpine.LFD.2.00.1001071633200.7821@localhost.localdomain>
	 <20100108004513.GF16076@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Thu, 07 Jan 2010 20:03:37 -0500
Message-ID: <1262912617.2659.90.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
X-OriginalArrivalTime: 08 Jan 2010 01:04:19.0586 (UTC) FILETIME=[81D05620:01CA8FFE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-08 at 01:45 +0100, Andi Kleen wrote: 
> > If that is ok, then why do the revalidate at all? Just do the open/close 
> > consistency and validate at open time, not mmap time.
> 
> That's exactly what my patch does :)

Actually, it doesn't....

It does remove the validation at mmap time, but it adds nothing at open
time to ensure that we call nfs_revalidate_mapping().

...and as I said, it breaks 'noac'.

Trond
