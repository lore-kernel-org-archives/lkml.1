Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbXHAOHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbXHAOHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932264AbXHAOHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:07:34 -0400
Received: from styx.suse.cz ([82.119.242.94]:40576 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932164AbXHAOHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:07:33 -0400
Date: Wed, 1 Aug 2007 16:07:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>, Ulrich Kunitz <kune@deine-taler.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Jan Kratochvil <honza@jikos.cz>, jakub@redhat.com
Subject: Re: Is PIE randomization breaking klibc binaries?
In-Reply-To: <46AF27E6.5080008@zytor.com>
Message-ID: <Pine.LNX.4.64.0708011604570.6311@jikos.suse.cz>
References: <20070720211300.GA21644@deine-taler.de> <46A131BF.4080404@zytor.com>
 <46A6624E.60003@redhat.com> <46A667BD.5080106@redhat.com>
 <20070724220053.GA20531@deine-taler.de> <46A68003.6060901@redhat.com>
 <46A68118.9080902@zytor.com> <20070725063243.GA25148@deine-taler.de>
 <Pine.LNX.4.64.0707311326090.26532@jikos.suse.cz> <46AF24B2.8070900@zytor.com>
 <Pine.LNX.4.64.0707311418040.26532@jikos.suse.cz> <46AF27E6.5080008@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007, H. Peter Anvin wrote:

> > So it seems to me that either it is something x86_64 specific or 
> > initramfs-specific. Will try to reproduce it.
> My guess would be the former, rather than the latter.  I haven't had a 
> chance to reproduce it myself yet (I'm on the road), but I will try to 
> get the time tomorrow.

I still wasn't successful reproducing it with 2.6.23-rc1 + 
pie-randomization.patch with klibc-1.5 on x86_64 system -- all programs 
from 'shared' and 'static' seem to be running well. 

Ulrich, could you please send me your .config? Thanks,

-- 
Jiri Kosina
SUSE Labs
