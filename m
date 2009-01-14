Return-Path: <linux-kernel-owner+w=401wt.eu-S1758191AbZANTni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbZANTni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbZANTnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:43:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53526 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860AbZANTnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:43:23 -0500
Subject: Re: kernel BUG at fs/ext/super.c:428
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20090114193844.GA18436@linux-os.sc.intel.com>
References: <20090110003645.GA16107@linux-os.sc.intel.com>
	 <20090113164842.c6aa7095.akpm@linux-foundation.org>
	 <20090114014434.GE14730@mit.edu> <496D526D.1010402@linux.intel.com>
	 <20090114044059.GA6222@mit.edu>
	 <20090114191632.GA13114@linux-os.sc.intel.com>
	 <1231961377.14825.51.camel@laptop>
	 <20090114193844.GA18436@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 20:42:49 +0100
Message-Id: <1231962169.14825.54.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 11:38 -0800, Pallipadi, Venkatesh wrote:

> > > Below is the result of full bisect

> > >     futex: rely on get_user_pages() for shared futexes

> > However does a futex change make ext3 crap its pants?
> > 
> > Is there anything more to it than start the machine, and reboot?
> 
> Just system startup and reboot is enough to reproduce the problem. And 100%
> reproducible. So, does seem to be any timing involved either.

That's very odd indeed, non of my test systems nor Ingo's ever triggered
this, and that patch has been in -tip for a rather long time.

CommitDate: Tue Sep 30 12:35:20 2008 +0200

That's 3.5 months of test time.. most curious. What kind of userland do
you have that triggers this?

