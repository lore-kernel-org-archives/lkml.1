Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYIRLxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYIRLxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 07:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYIRLxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 07:53:24 -0400
Received: from web32604.mail.mud.yahoo.com ([68.142.207.231]:27983 "HELO
	web32604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752673AbYIRLxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 07:53:23 -0400
X-YMail-OSG: Ik50CIQVM1nsRVnMtnX8LX0gRWpFqHOS4tAIWELGvbkThmKvyIcUG42lc3ck5V.YinL239NW2uGAnLj2kKS4eTb3CVf7YosKBjYLXnTm0uQZFT7xmm1Ah5eKisyKxhxOBMlyWa2l5PNBF1IJgABBHk5pIq76vA--
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Thu, 18 Sep 2008 04:53:22 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Banks <gnb@melbourne.sgi.com>,
       linux-nfs list <linux-nfs@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Peter zijlstra <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <688309.69831.qm@web32604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Andrew Morton <akpm@linux-foundation.org>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: Greg Banks <gnb@melbourne.sgi.com>; linux-nfs list <linux-nfs@vger.kernel.org>; linux-kernel@vger.kernel.org; Peter zijlstra <a.p.zijlstra@chello.nl>
> Sent: Thursday, September 18, 2008 10:47:33 AM
> Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
> 
> On Thu, 18 Sep 2008 01:38:57 -0700 (PDT) Martin Knoblauch 
> wrote:
> 
> > > No.  mount(8) will pass unrecognised options straight down into the
> > > filesystem driver.
> > >
> > 
> >  Has that always been the case, or is it a recent change? I have to support 
> RHEL4 userland, which is not really new.
> 
> It's been that way for ever and ever.  It's how all these guys:
> 
> y:/usr/src/25> grep Opt_ fs/*/super.c|wc
>     781    2626   33703
> 
> get handled.

 while that seems to be not to complicated, I seem to have a problem passing the mount options to the kernel. They come down as mount data version "6". Apparently mount(8) or mount.nfs(8) are doing the parsing and send down the legacy data block. So, what is the minimum version of mount or mount.nfs that pass the options down unaltered?

Cheers
Martin

