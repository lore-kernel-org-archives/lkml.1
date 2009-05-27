Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbZE0Sb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbZE0Sb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759349AbZE0Sbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:31:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45541 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349AbZE0Sbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:31:48 -0400
Date: Wed, 27 May 2009 20:38:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Andi Kleen <andi@firstfloor.org>, Harald Welte <HaraldWelte@viatech.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: LOCK prefix on uni processor has its use
Message-ID: <20090527183825.GV1065@one.firstfloor.org>
References: <200905221139.26941.lkml@morethan.org> <20090527170118.GC4024@prithivi.gnumonks.org> <87vdnmmnac.fsf@basil.nowhere.org> <200905271322.41768.lkml@morethan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905271322.41768.lkml@morethan.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I still have not come up with a solid, testable, theory to explain the
> order of magnitude in up-time before the kernel locks with/with-out 'lock'.

What I would do is to try to track down in which file it happens.
Compile individual subdirectories of the kernel with LOCK prefix,
then down to files.

Also always double check the results.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
