Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZFSFcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZFSFcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 01:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZFSFcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 01:32:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:47408 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbZFSFcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 01:32:05 -0400
Date: Thu, 18 Jun 2009 22:32:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tglx@tglx.de, alan@lxorguk.ukuu.org.uk,
       rjw@sisk.pl, netdev@vger.kernel.org, mingo@elte.hu, dwmw2@infradead.org,
       alsa-devel@alsa-project.org, dri-devel@lists.sourceforge.net
Subject: Re: kerneloops.org report for the week of June 14 2009
Message-ID: <20090618223238.4d6b6707@infradead.org>
In-Reply-To: <b6c5339f0906181008v1cd4b06aof866ea9a91d2eb84@mail.gmail.com>
References: <20090614173331.18f01123@infradead.org>
	<b6c5339f0906181008v1cd4b06aof866ea9a91d2eb84@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009 13:08:39 -0400
Bob Copeland <me@bobcopeland.com> wrote:

> On Sun, Jun 14, 2009 at 8:33 PM, Arjan van de
> Ven<arjan@infradead.org> wrote:
> > Rank 9: minstrel_get_rate (warning)
> >        Reported 64 times (384 total reports)
> >        Issue with the ath5k driver
> >        This warning was last seen in version 2.6.30-rc3, and first
> > seen in 2.6.27.12. More info:
> > http://www.kerneloops.org/searchweek.php?search=minstrel_get_rate
> 
> I believe this is fixed by http://lkml.org/lkml/2009/6/5/269, now
> in pre-2.6.31.  Hmm, odd though, we should be seeing reports from
> other wireless drivers since it's a general memory corruption
> unrelated to ath5k (but not all use the mac80211 rate controllers).
> 

well.. out of the 534 reports or so that I have by now... 525 have
ath5k loaded.....

it's not 100% but it'd pretty close.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
