Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbZJFEp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbZJFEp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 00:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZJFEp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 00:45:26 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38337
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbZJFEp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 00:45:26 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: berk walker <berk@panix.com>
Subject: Re: [PATCH 1/1] md: drivers/md/unroll.pl replaced with awk analog
Date: Mon, 5 Oct 2009 23:44:46 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; x86_64; ; )
Cc: Vladimir Dronnikov <dronnikov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, neilb@suse.de
References: <4aca1863.0a1ad00a.33bf.1017@mx.google.com> <200910051630.51039.rob@landley.net> <4ACA87DA.7000607@panix.com>
In-Reply-To: <4ACA87DA.7000607@panix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910052344.46809.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 October 2009 18:57:14 berk walker wrote:
> Rob Landley wrote:
> > On Monday 05 October 2009 11:01:39 Vladimir Dronnikov wrote:
> >> From: Vladimir Dronnikov <dronnikov@gmail.com>
> >>
> >> drivers/md/unroll.pl replaced by awk script to drop build-time
> >> dependency on perl
> >>
> >> Signed-off-by: Vladimir Dronnikov <dronnikov@gmail.com>
> >
> > Acked-by: Rob Landley <rob@landley.net>
> >
> > We already discussed this on another mailing list, thread starts at:
> >
> > http://lists.impactlinux.com/pipermail/firmware-impactlinux.com/2009-Octo
> >ber/000328.html
> >
> > I've added this as patch #4 in the perl removal series I've submitted
> > during the last few merge windows.
> >
> > Thanks,
> >
> > Rob
>
> Why is perl being removed? [I know that I have missed a lot]
> berk-

Before 2.6.25 the kernel build had never used perl, and the first perl removal 
patches were submitted for 2.6.26, so the real question is "why was it added, 
and was it worth it?"

There was a long thread on an earlier submission of the patches, which Alan 
Cox concluded (as far as I'm concerned, unless Linus, Andrew Morton, or maybe 
Al Viro want to weigh in) with this post:

  http://lkml.indiana.edu/hypermail/linux/kernel/0901.1/02108.html

Archives are linked from there, you might have to check adjacent weeks too.

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
