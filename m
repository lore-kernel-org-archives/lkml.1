Return-Path: <linux-kernel-owner+w=401wt.eu-S1762245AbXGORSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762245AbXGORSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 13:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758624AbXGORSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 13:18:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:65253 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792AbXGORSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 13:18:12 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
To: Matt Mackall <mpm@selenic.com>, Rene Herman <rene.herman@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Reply-To: 7eggert@gmx.de
Date: Sun, 15 Jul 2007 19:17:39 +0200
References: <8FO1e-2jW-35@gated-at.bofh.it> <8FYWD-2eS-7@gated-at.bofh.it> <8GdsH-8dc-13@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it> <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it> <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IA7j1-0000j9-I3@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19MI/xwdaS38M6Us6jBs6jSskEyp7JoP6xp9uZ
 Ml01509iZVlb7E+hkscAqoDNBsRq/p6VMRUlEK+iQwB1tBuUR1
 FsMc9vX4xv2VUN61OUMEQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall <mpm@selenic.com> wrote:
> On Fri, Jul 13, 2007 at 03:20:54PM +0200, Rene Herman wrote:

>> As far as I'm aware, the actual reason for 4K stacks is that after the
>> system has been up and running for some time getting "1 physically
>> contiguous pages" becomes significantly easier than 2 which wouldn't be
>> arbitrary.
> 
> If there are exactly two free pages in the system, the odds of them
> being buddies (ie adjacent AND properly aligned) is quite small. The
> available page pool has to grow quite a bit before the availability of
> order-1 page pairs approaches 100%.

If there are exactly two free pages in a system, the odds of starting any
program are not very good. You'll have to swap, and if you do, you can swap
two more pages in order to free enough RAM for the stack.
-- 
The secret of the universe is #@*%! NO CARRIER 

Friﬂ, Spammer: TqB@mxlqnP.7eggert.dyndns.org -kplBVgN@7eggert.dyndns.org
 BpRVhx@1Q.7eggert.dyndns.org ozy0XBmkB@m1Sh.7eggert.dyndns.org
