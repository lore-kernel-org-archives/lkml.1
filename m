Return-Path: <linux-kernel-owner+w=401wt.eu-S940194AbXGaBlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940194AbXGaBlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 21:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761588AbXGaBlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 21:41:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49505 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344AbXGaBlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 21:41:11 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Testing of CPRM on SD Card
Date: Tue, 31 Jul 2007 07:10:14 +0530
Message-ID: <0A50DBE80DD6674E94F7269DC964A7B6441418@dbde01.ent.ti.com>
In-Reply-To: <20070730161114.053bef44@the-village.bc.nu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Testing of CPRM on SD Card
Thread-Index: AcfSuzHsRKveNMdVTQOKX4/kTZc/qQAV2tPQ
From: "Sriram, Kannan" <ksriram@ti.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Midhun A" <midhunagni@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.arm.linux.org.uk>,
       <linux-mtd@lists.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Tuesday, July 31, 2007 12:11 AM
> To: Midhun A
> Cc: Sriram, Kannan; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.arm.linux.org.uk; linux-mtd@lists.infradead.org
> Subject: Re: Testing of CPRM on SD Card
> 
> On Mon, 30 Jul 2007 20:23:42 +0530
> "Midhun A" <midhunagni@gmail.com> wrote:
> 
> > Hey All,
> >
> >     Thanks a lot for the replies. I have the development keys. But
the
> > algorithm and some intellectual property needs to be licenced from
the
> > 4C entity guys to implement it. As of now I just want to test the
CPRM
> > functionality. So licensing the algo for a prototype testing is a
huge
> > cost.
>

If you have the development keys, then you should typically have the
dummy "secret constant" used in the C2 algorithm as well. Contrary to
popular belief, the C2 algorithm by itself is not proprietary, just the
256 byte secret constant used inside the C2 algorithm. Also, if you want
to just "test" CPRM, you have all the stuff you need (not the real
stuff, but stuff that you can validate using your development keys) in
the name of dummy keys. Some sample input/ output data as well as
related dummy keys and the C2 algorithms are all available at the 4C
website for free download.

I had once (long ago) validated CPRM purely using stuff downloaded from
4C (free download). But my setup was not Linux; rather on a DSP
simulator platform, and was "low level".

But if you are looking for a quick test using a real SD-card, then like
I said, your development keys won't help. You need a real set of valid
"production keys" and these I bet are very hard to get!
 
> Good good, the higher the better and the less this evil stuff gets
used.

