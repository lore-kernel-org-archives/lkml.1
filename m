Return-Path: <linux-kernel-owner+w=401wt.eu-S1761306AbYENBEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306AbYENBEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 21:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbYENBD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 21:03:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50588
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757574AbYENBD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 21:03:58 -0400
Date: Tue, 13 May 2008 18:03:52 -0700 (PDT)
Message-Id: <20080513.180352.93882752.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       jmforbes@linuxtx.org, zwane@arm.linux.org.uk, tytso@mit.edu,
       rdunlap@xenotime.net, davej@redhat.com, chuckw@quantumlinux.com,
       reviews@ml.cw.f00f.org, mkrufky@linuxtv.org, cebbert@redhat.com,
       cavokz@gmail.com, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 25/37] sparc: Fix mremap address range validation.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0805131327130.3019@woody.linux-foundation.org>
References: <20080513200453.064446337@mini.kroah.org>
	<20080513201229.GZ31167@suse.de>
	<alpine.LFD.1.10.0805131327130.3019@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 May 2008 13:28:32 -0700 (PDT)

> On Tue, 13 May 2008, Greg KH wrote:
> >
> > From: David S. Miller <davem@davemloft.net>
> > 
> > Just like mmap, we need to validate address ranges regardless
> > of MAP_FIXED.
> 
> Hmm. I don't have this one in my tree. Is it obsoleted by the other 
> patches I do have, or what? If so, some comment about that would be nice.

It's pending, sorry I just didn't push it to you yet.
