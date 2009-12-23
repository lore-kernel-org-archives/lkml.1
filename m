Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbZLWUgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbZLWUgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 15:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZLWUf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 15:35:59 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:45680 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695AbZLWUf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 15:35:59 -0500
Message-ID: <4B327EE5.6060306@lll.lu>
Date: Wed, 23 Dec 2009 21:34:45 +0100
From: alain <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: "markh@compro.net" <markh@compro.net>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
References: <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain>	 <4B310879.9050701@compro.net>	 <1261525076.16916.4.camel@localhost.localdomain>	 <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net>	 <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com>	 <4B32386B.2060509@compro.net>	 <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain>	 <87bphpd4rt.fsf@basil.nowhere.org> <4B32565E.6000501@compro.net>	 <20091223191806.GA3336@linux-os.sc.intel.com> <4B3270FE.5090607@compro.net> <1261600243.16916.56.camel@localhost.localdomain>
In-Reply-To: <1261600243.16916.56.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
> MSI interrupt being delivered to CPU 0. I cannot think of any reason why
> this can break dma. We can probably try adding some dummy HPET read
> after dma write, to see if that flushes things properly.

Shouldn't that be "... some dummy HPET read _before_ dma write...". In
order to ensure that DMA cache is consistent _before_ dma controller
reads it?

Regards,

Alain
