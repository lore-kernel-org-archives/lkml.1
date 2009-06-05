Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbZFENoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbZFENoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbZFENns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:43:48 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:45812 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbZFENnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:43:47 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: VIA CPU PCI cache line size (Re: Linux 2.6.30-rc8 [also: VIA Support])
Date: Fri, 5 Jun 2009 08:43:40 -0500
User-Agent: KMail/1.9.9
Cc: Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090605001510.GA2479@redhat.com> <20090605110819.GI4421@prithivi.gnumonks.org>
In-Reply-To: <20090605110819.GI4421@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906050843.42593.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 5 2009, Harald Welte wrote:
> On Thu, Jun 04, 2009 at 08:15:10PM -0400, Dave Jones wrote:
> 
> > I meant just doing something like this..
> > 
> > (untested)
> > 
> > I'm not sure if the clflush_size==0 case can happen, which is why
> > I left the fallback.  Maybe on ancient cpus?
> 
> this patch looks fine with me.  I didn't do any testing yet either, though.
> 

Although not coded as Dave J. suggests - I have been re-setting the
that value to the cpu cache line size for a week or two now.

It doesn't break anything in an obvious way - does seem to help.

Mike
