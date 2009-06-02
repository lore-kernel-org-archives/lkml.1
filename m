Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbZFBOC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbZFBOC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbZFBOCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:02:49 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:47561 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbZFBOCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:02:49 -0400
Date: Tue, 2 Jun 2009 16:02:50 +0200
From: Andreas Mohr <andi@lisas.de>
To: isdn@linux-pingi.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mISDN GIT: hfcpci cleanup failure on IRQ weirdness
Message-ID: <20090602140250.GA3607@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602130649.GA14794@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I have the suspicion that maybe I shouldn't be loading hisax upon boot
> (and then immediately removing it before launching mISDN stuff),
> since hfcpci acts very weird - perhaps it cannot recover card state fully
> after hisax fumbling.

Indeed, manually killed all hisax modules on the system, rebooted, and -
it worked, immediately!
(test call SIP -> Asterisk -> LCR -> ISDN -> out -> ISDN)

IOW, we've got an unfortunate driver init state handling issue which one
should perhaps investigate to make the driver more robust against
varying hardware state.
(my IRQ patch was a first step I guess ;)

misdn_log still acts weird, though...

Thanks for all your important ISDN work! (given the sizeable number of
commits mISDN will rather soon get there I think)

BTW, could isdnlog be adapted to support mISDN relatively easily?
(since adding CAPI support would take longer I guess)
My guys are going semi-ballistic with their isdnlog taken out and shot ;)

Andreas Mohr
