Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbZCRQsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbZCRQsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZCRQsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:48:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48168 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbZCRQsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:48:09 -0400
Date: Wed, 18 Mar 2009 17:47:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: Lubomir Rintel <lkundrak@v3.sk>, Joerg Roedel <joerg.roedel@amd.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@redhat.com>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: e1000e 0000:00:19.0: DMA-API: device driver tries to free DMA
	memory it has not allocated [device address=0x0000000052ff084a]
	[size=90 bytes]
Message-ID: <20090318164731.GB31315@elte.hu>
References: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com> <20090317120112.GP6159@amd.com> <20090318093847.GC5879@elte.hu> <20090318115615.GS6159@amd.com> <20090318120458.GA1601@elte.hu> <36697.89.102.207.186.1237380871.squirrel@mail.v3.sk> <20090318140949.GA20852@elte.hu> <F169D4F5E1F1974DBFAFABF47F60C10A1E8795AC@orsmsx507.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F169D4F5E1F1974DBFAFABF47F60C10A1E8795AC@orsmsx507.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Brandeburg, Jesse <jesse.brandeburg@intel.com> wrote:

> Ingo Molnar wrote:
> > * Lubomir Rintel <lkundrak@v3.sk> wrote:
> > 
> >> On Wed, March 18, 2009 8:04 am, Ingo Molnar wrote:
> >>> 
> >>> ( e1000e Cc:s added. A new debug feature, CONFIG_DMA_API_DEBUG=y,
> >>>   has triggered the warning below in e1000_put_txbuf(). )
> >> 
> >> http://lkml.org/lkml/2009/3/2/318
> 
> We are still looking for more testing from the general community of 
> this patch, in particular if any tx hangs are reported.  Thanks in 
> advance for any reports.--

Yeah - already picked it up into tip:out-of-tree and it passed about 
a hundred bootup tests on various e1000e using systems already - 
with no problems whatsoever. Will let you know if anything breaks - 
e1000e has been rock solid for me in the .29 cycle.

	Ingo
