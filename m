Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbZAVRv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbZAVRv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbZAVRog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:44:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37638 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758317AbZAVRof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:44:35 -0500
Date: Thu, 22 Jan 2009 18:44:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: build issue #587 for v2.6.29-rc2-13-gf3b8436
	:_set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
Message-ID: <20090122174424.GB22992@elte.hu>
References: <200901221812.20702.toralf.foerster@gmx.de> <20090122173020.GI3171@fedora.yogi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090122173020.GI3171@fedora.yogi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Balaji Rao <balajirrao@openmoko.org> wrote:

> Content-Description: Toralf Förster <tfoerste@n22.n22_domain>: build issue #587 for v2.6.29-rc2-13-gf3b8436 :
> > Date: Thu, 22 Jan 2009 18:10:21 +0100
> > From: Toralf F?rster <tfoerste@n22.n22_domain>
> > To: tfoerste@n22.n22_domain
> > Subject: build issue #587 for v2.6.29-rc2-13-gf3b8436 :
> > 
> > Hello,
> > 
> > the build (.config attached) failed, make ends with :
> > ...
> 
> Hi,
> 
> This is known for more than two weeks. Fixes in various forms have been 
> sent on this list, but somehow it isn't making it to the destination..

i've queued up a fix more than a week ago to the irq tree. The bug came in 
via the ARM tree. Linus is on a conference right now so there's no pulls 
going on.

	Ingo
