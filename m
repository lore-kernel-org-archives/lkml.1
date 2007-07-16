Return-Path: <linux-kernel-owner+w=401wt.eu-S1764769AbXGPXmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764769AbXGPXmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXGPXmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:42:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:54848 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbXGPXmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:42:38 -0400
Date: Tue, 17 Jul 2007 01:42:20 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Ray Lee <ray-lk@madrabbit.org>, Rene Herman <rene.herman@gmail.com>,
       Bodo Eggert <7eggert@gmx.de>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
In-Reply-To: <9a8748490707161554j1fa7625fq1f1cb7e6aa359715@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0707170134390.29868@be1.lrz>
References: <8FO1e-2jW-35@gated-at.bofh.it> <8Gj55-hJ-5@gated-at.bofh.it> 
 <8GkNo-2Vb-1@gated-at.bofh.it> <8GtnN-7TG-23@gated-at.bofh.it> 
 <8GVjY-PL-25@gated-at.bofh.it> <E1IA7j1-0000j9-I3@be1.lrz>  <469A5D7C.5010904@gmail.com>
  <Pine.LNX.4.58.0707161523500.25779@be1.lrz>  <469BF104.1040703@gmail.com>
  <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
 <9a8748490707161554j1fa7625fq1f1cb7e6aa359715@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/7W93IKSmkguvZOowsElWm4DZKx+l1U2+Eyt6
 poWWIHopzdco65v5G61TOXqMGU/cdVJ1SjUTNG+/ExqhxO4Jex
 hXRnLDk9lIBfMbua9E6kQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Jesper Juhl wrote:

> Please note that I was not trying to remove the 8K stack option right
> now - heck, I didn't even add anything to feature-removal-schedule.txt
> - all I wanted to accomplish with the patch that started this threas
> was;  a) indicate that the 4K option is no longer a debug thing  and

Very ACK.

> b) make 4K stacks the default option in vanilla kernel.org kernels as
> a gentle nudge towards getting people to start fixing the code paths
> that are not 4K stack safe.

That's the big NACK. It's OK for MM, where things are supposed to be in a 
not well-tested state, but for running possibly mission-critical systems,
you should take no risk.

If you'd run a 4K stack on the NFS+XFS+LVM+dmcrypt+MD+somethingmore 
setup driving your loved one's life support, you may go ahead.
-- 
I'm a member of DNA (National Assocciation of Dyslexics).
	-- Storm in <5Z4Z7.52353$4x4.6445347@news2-win.server.ntlworld.com>
