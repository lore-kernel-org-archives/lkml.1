Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZHZOLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZHZOLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbZHZOLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:11:12 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:41814 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445AbZHZOLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:11:11 -0400
Date: Wed, 26 Aug 2009 09:11:03 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] document flash/RAID dangers
Message-ID: <20090826141103.GA1497509@hiwaay.net>
References: <ddefx-5R-37@gated-at.bofh.it> <ddep7-bI-7@gated-at.bofh.it> <ddeyR-iy-11@gated-at.bofh.it> <ddeyR-iy-9@gated-at.bofh.it> <ddeIu-n9-9@gated-at.bofh.it> <ddeSb-th-29@gated-at.bofh.it> <ddoRI-11a-39@gated-at.bofh.it> <ddpkB-1jQ-1@gated-at.bofh.it> <20090826134045.GA1516467@hiwaay.net> <20090826144716.486a0d44@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826144716.486a0d44@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Alan Cox <alan@lxorguk.ukuu.org.uk> said:
> > The issues being raised here are not specific to extX, MD RAID, or Linux
> > at all; they are problems with non-"enterprise-class" RAID setups.
> > There's a reason enterprise-class RAID costs a lot more money than the
> > card you can pick up at Fry's.
> 
> And you will still need backups ;)

Yep.  RAID (of any class) != fail safe.

> A long time ago I worked on a fault tolerant news server with dual
> alphaserver boxes and a shared disk array. A power system failure took
> out both the alpha boxes and the disk controllers and all the disks.

Hey, that's not funny!  I'm typing this on a dual AlphaServer cluster
with a shared disk array (with dual battery backup even), and we had a
power failure at the NOC yesterday (that then tripped a breaker,
although it was between the generator and the UPS, so nothing went
down).

No matter how redundant you make things, a "no single point of failure"
setup still can fail, often in "interesting" ways that nobody
anticipated.

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
