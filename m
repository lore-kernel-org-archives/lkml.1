Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbXE3BEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbXE3BEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 21:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbXE3BEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 21:04:41 -0400
Received: from mail30.syd.optusnet.com.au ([211.29.133.193]:46378 "EHLO
	mail30.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbXE3BEk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 21:04:40 -0400
From: Con Kolivas <kernel@kolivas.org>
To: "Antonino Ingargiola" <tritemio@gmail.com>
Subject: Re:swap prefetch improvements
Date: Thu, 31 May 2007 12:03:02 +1000
User-Agent: KMail/1.9.5
Cc: "ck list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <200705270800.06612.kernel@kolivas.org> <5486cca80705291253vb793caqd632f3adbb2479ad@mail.gmail.com> <5486cca80705291259s63edf2bcv7035f700aa23e8b1@mail.gmail.com>
In-Reply-To: <5486cca80705291259s63edf2bcv7035f700aa23e8b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705311203.02582.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 May 2007 05:59, Antonino Ingargiola wrote:
> 2007/5/29, Antonino Ingargiola <tritemio@gmail.com>:
> [cut]
>
> > Swap Prefetch OFF
> > # ./sp_tester
> > Ram 776388000  Swap 514040000
> > Total ram to be malloced: 1033408000 bytes
> > Starting first malloc of 516704000 bytes
> > Starting 1st read of first malloc
> > Touching this much ram takes 1642 milliseconds
> > Starting second malloc of 516704000 bytes
> > Completed second malloc and free
> > Sleeping for 60 seconds
> > Important part - starting reread of first malloc
> > Completed read of first malloc
> > Timed portion 9089 milliseconds
> >
> >
> > Swap Prefetch OFF
> > # ./sp_tester
> > Ram 776388000  Swap 514040000
> > Total ram to be malloced: 1033408000 bytes
> > Starting first malloc of 516704000 bytes
> > Starting 1st read of first malloc
> > Touching this much ram takes 1635 milliseconds
> > Starting second malloc of 516704000 bytes
> > Completed second malloc and free
> > Sleeping for 60 seconds
> > Important part - starting reread of first malloc
> > Completed read of first malloc
> > Timed portion 1783 milliseconds
>
> The second case is clearly with swap prefetch *ON*, sorry.

Thanks very much for testing! The patch has been taken up by Andrew for the 
next -mm.

どうも
-- 
-ck
