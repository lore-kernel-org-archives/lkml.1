Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbZBPJi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbZBPJi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 04:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbZBPJig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 04:38:36 -0500
Received: from sh.osrg.net ([192.16.179.4]:53314 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234AbZBPJif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 04:38:35 -0500
Date: Mon, 16 Feb 2009 18:38:00 +0900
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, avishay@gmail.com, jeff@garzik.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       osd-dev@open-osd.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/8] exofs: Kbuild, Headers and osd utils
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49992F99.1060404@panasas.com>
References: <499928A3.60507@panasas.com>
	<20090216180028C.fujita.tomonori@lab.ntt.co.jp>
	<49992F99.1060404@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090216183750H.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 16 Feb 2009 18:38:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 11:19:21 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> >> Also looking
> >> ahead I will have RAID 0, 1, 5, and 6 on objects of different devices. bio
> >> is the perfect collector for memory information in this situation.
> > 
> > You will add such features to exofs, handling multiple devices
> > internally?
> > 
> 
> Multiple objects on Multiple devices, Yes.

I thought that exofs is kinda example (reference) file system.

Nobody has seen your code. Let's discuss when we have the
code. Over-designing for what we've not seen is not a good idea.


> >> exofs is not the first and only file system who is using bios. Proof of
> >> the matter is that block exports a bio submit routine.
> > 
> > Seems that exofs just passes pages and the ULD sends a SCSI command
> > including these pages. I don't see how exofs needs to handle bio
> > directly.
> > 
> 
> How do you propose to collect these pages? and keep them without allocating
> an extra list? without pre-allocating a struct request? and without re-inventing
> the bio structure?

I don't think that allocating an extra list (or something) to keep
them hurts performance. We can talk about it when you have the real
performance results.
