Return-Path: <linux-kernel-owner+w=401wt.eu-S1760768AbXGDBNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768AbXGDBNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 21:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbXGDBNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 21:13:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754973AbXGDBNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 21:13:33 -0400
Date: Tue, 3 Jul 2007 18:12:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: 2.6.22-rc7: known regressions with patches
In-Reply-To: <200707040138.13538.ak@suse.de>
Message-ID: <alpine.LFD.0.98.0707031811500.9434@woody.linux-foundation.org>
References: <468A7D24.3040004@googlemail.com>
 <alpine.LFD.0.98.0707031441480.9434@woody.linux-foundation.org>
 <20070703221210.GA29959@atjola.homenet> <200707040138.13538.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Jul 2007, Andi Kleen wrote:
> 
> Linus, also what about the revert of the HPET reservation? That would
> fix a clear regression too.

Thanks for reminding me. It probably isn't much of a regression any more 
(since we added the code to not use the HPET when it doesn't seem to be 
working), but yes, that should go in too.

Applied and pushed out. Now we just need people to test and verify that 
the regressions are gone..

		Linus
