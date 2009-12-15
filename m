Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbZLOOFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbZLOOFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760273AbZLOOFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:05:09 -0500
Received: from smtp.nokia.com ([192.100.122.230]:32267 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760276AbZLOOFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:05:05 -0500
Subject: Re: linux-next: manual merge of the voltage tree with Linus' tree
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
To: ext Liam Girdwood <lrg@slimlogic.co.uk>
Cc: "Ujfalusi Peter (Nokia-D/Tampere)" <peter.ujfalusi@nokia.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       Rajendra Nayak <rnayak@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
       Balaji T K <balajitk@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <1260879242.3591.335.camel@odin>
References: <20091215133808.cd3d4b8b.sfr@canb.auug.org.au>
	 <1260870485.3591.25.camel@odin>  <1260879242.3591.335.camel@odin>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Dec 2009 16:04:44 +0200
Message-ID: <1260885884.31691.72.camel@keskisaa-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Dec 2009 14:04:47.0100 (UTC) FILETIME=[8F45EBC0:01CA7D8F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 13:14 +0100, ext Liam Girdwood wrote:
> On Tue, 2009-12-15 at 09:48 +0000, Liam Girdwood wrote:
> > Hi Stephen,
> > 
> > On Tue, 2009-12-15 at 13:38 +1100, Stephen Rothwell wrote:
> > > Hi Liam,
> > > 
> > > Today's linux-next merge of the voltage tree got a conflict in
> > > drivers/regulator/twl-regulator.c between commit
> > > 441a450554dada1c59fc06fdf068cb0eeba53c6d ("regulator: Add support for
> > > twl6030 regulators") from Linus' tree and commits
> > > 6360cf42ae51be5f6e6e72d6e81f202d9db0f7e9 ("twl4030-regulator: Remove
> > > regulator from all groups when disabling") and
> > > 3277b9fce0fcaa68d5947429e062163852ebc6fb ("twl4030-regulator: Add all TWL
> > > regulators to twreg_info") from the voltage tree.
> > > 
> > > I cannot begin to fix this mess up.  I do wonder why the regulator patch
> > > above was never in linux-next before being sent upstream yesterday
> > > (Samuel?).  All I can do is use the version of the voltage tree from
> > > next-20091120 (commit id b0a7a2ad0aebb35934de6d2509c73fe93a362c0e) for
> > > today and hope that Liam can do the merge with Linus' tree.
> > > 
> > 
> > Sorry about this. There were some large patch sets that did span both
> > mfd and regulator recently.
> > 
> > I'll fix and do my pull request today.
> 
> Peter, Juha,
> 
> I've fixed up regulator for-next against upstream and now get a build
> failure on twl-regulator.c (possibly related to mfd/twl-codec.c build
> failure today ?)
> Can you check this and send me patch before I issue a pull request.
> Fwiw, the regulator pull request is now blocking on this issue.
> 
> Thanks.
> 
> Liam

Hi Liam

I should be able to fix at the very least most of those during tomorrow,
it appears that some changes with the 6030 additions confused the
patches I sent to you earlier. I'll send you a patch tomorrows

Best regards,
Juha K-S


