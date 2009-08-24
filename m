Return-Path: <linux-kernel-owner+w=401wt.eu-S1751987AbZHXIty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbZHXIty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbZHXIty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:49:54 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:17958 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZHXItx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:49:53 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz1432R98dNa594i873fizz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KOVHUW-02-5VK-02
X-M-MSG: 
Date: Mon, 24 Aug 2009 10:49:35 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Valdis.Kletnieks@vt.edu
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/15] x86, sched: Add config option for multi-node CPU
	scheduling
Message-ID: <20090824084935.GT29515@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820131521.GP29327@alberich.amd.com> <57214.1250862635@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <57214.1250862635@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 24 Aug 2009 08:49:36.0437 (UTC) FILETIME=[CEF5FE50:01CA2497]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 09:50:35AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 20 Aug 2009 15:15:21 +0200, Andreas Herrmann said:
> > 
> > I've decided to add this as a subitem of MC scheduling.
> > I think the normal case will be that a multi-node CPU has more than 1
> > core on each of its nodes. Thus using MN scheduling without MC
> > scheduling does not make much sense.
> > 
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > ---
> >  arch/x86/Kconfig |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> Is this patch series bisectable? I admit not having checked deeply, and
> at least at first glance the rest looks sane - but usually Kconfig changes
> are kept until the *last* patch so that there's no chance of inter-patch
> dependencies breaking...

It should be bisectable -- i.e. it shouldn't cause build errors.
Furthermore the real usage of MN domains gets activated with
patch 7.


Regards,

Andreas


-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


