Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZLWVeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZLWVeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbZLWVea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:34:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:37501 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640AbZLWVe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:34:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,444,1257148800"; 
   d="scan'208";a="581690419"
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: alain <alain@knaff.lu>
Cc: "markh@compro.net" <markh@compro.net>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4B327EE5.6060306@lll.lu>
References: <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain>
	 <4B310879.9050701@compro.net>
	 <1261525076.16916.4.camel@localhost.localdomain>
	 <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net>
	 <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com>
	 <4B32386B.2060509@compro.net>
	 <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain>
	 <87bphpd4rt.fsf@basil.nowhere.org> <4B32565E.6000501@compro.net>
	 <20091223191806.GA3336@linux-os.sc.intel.com> <4B3270FE.5090607@compro.net>
	 <1261600243.16916.56.camel@localhost.localdomain> <4B327EE5.6060306@lll.lu>
Content-Type: text/plain
Date: Wed, 23 Dec 2009 13:34:28 -0800
Message-Id: <1261604068.16916.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 12:34 -0800, alain wrote:
> Pallipadi, Venkatesh wrote:
> > MSI interrupt being delivered to CPU 0. I cannot think of any reason why
> > this can break dma. We can probably try adding some dummy HPET read
> > after dma write, to see if that flushes things properly.
> 
> Shouldn't that be "... some dummy HPET read _before_ dma write...". In
> order to ensure that DMA cache is consistent _before_ dma controller
> reads it?
> 

Yes. I meant after the contents of the buffer is changed and before the
DMA transfer and the controller reading it.

Thanks,
Venki


