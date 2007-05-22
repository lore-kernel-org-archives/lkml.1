Return-Path: <linux-kernel-owner+w=401wt.eu-S1763100AbXEVH2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763100AbXEVH2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 03:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbXEVH2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 03:28:17 -0400
Received: from www.osadl.org ([213.239.205.134]:52499 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755185AbXEVH2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 03:28:17 -0400
Subject: Re: [PATCH -ak] Fix missing include
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200705220820.11688.ak@suse.de>
References: <1179777839.12708.42.camel@chaos>
	 <200705220820.11688.ak@suse.de>
Content-Type: text/plain
Date: Tue, 22 May 2007 09:28:15 +0200
Message-Id: <1179818895.12708.98.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 08:20 +0200, Andi Kleen wrote:
> On Monday 21 May 2007 22:03, Thomas Gleixner wrote:
> > ftp://firstfloor.org/pub/ak/x86_64/quilt/x86_64-2.6.22-rc2-070521-1.bz2
> >
> > explodes in various places due to missing defines of __cold. We can't
> > rely on the assumption that linux/compiler.h is included magically
> > before bug.h is included. Include it explicitely.
> 
> Hmm, somehow it worked here. Perhaps longer term it would be a good
> idea to turn compiler.h into an -include

Might be not a bad idea. > 300 files include it directly and it's
included from sched.h & co as well.

	tglx


