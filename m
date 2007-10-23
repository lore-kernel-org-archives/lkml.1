Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbXJWXSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbXJWXSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 19:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXJWXSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 19:18:39 -0400
Received: from ns2.suse.de ([195.135.220.15]:46755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbXJWXSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 19:18:38 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH -v7 1/3] x86 boot: setup data
Date: Wed, 24 Oct 2007 01:18:20 +0200
User-Agent: KMail/1.9.6
Cc: "Huang, Ying" <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1193126771.23935.79.camel@caritas-dev.intel.com> <471E70E0.2090802@goop.org>
In-Reply-To: <471E70E0.2090802@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710240118.21160.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2007 00:08:32 Jeremy Fitzhardinge wrote:
> Huang, Ying wrote:
> > This patch add a field of 64-bit physical pointer to NULL terminated
> > single linked list of struct setup_data to real-mode kernel
> > header. This is used as a more extensible boot parameters passing
> > mechanism.
> >   
> 
> As a general comment, I can't say I'm thrilled about sticking the copied
> setup data at the end of the initial pagetables.  This is already a
> fairly complex area, and changing it touches a surprisingly large number
> of places.  I wonder if there isn't a better way to deal with this
> (possibly by fixing up the generation of the initial pagetables in the
> process).

With the early reserve code in 
ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-reserve
and
ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-alloc
this could be likely done cleaner.

-Andi
