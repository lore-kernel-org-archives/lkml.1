Return-Path: <linux-kernel-owner+w=401wt.eu-S1762856AbZC0AQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762856AbZC0AQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762790AbZC0APk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:15:40 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:49319 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762736AbZC0APg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:15:36 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] Make relatime default
Date: Fri, 27 Mar 2009 01:15:27 +0100
User-Agent: KMail/1.9.9
Cc: alan@lxorguk.ukuu.org.uk, mjg@redhat.com, tytso@mit.edu, mingo@elte.hu,
       jack@suse.cz, akpm@linux-foundation.org, arjan@infradead.org,
       a.p.zijlstra@chello.nl, npiggin@suse.de, jens.axboe@oracle.com,
       drees76@gmail.com, jesper@krogh.cc, linux-kernel@vger.kernel.org,
       oleg@redhat.com, roland@redhat.com
References: <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain> <20090326174956.GB7198@srcf.ucam.org> <20090326175314.GC7198@srcf.ucam.org> <20090326184838.26166549@lxorguk.ukuu.org.uk> <20090326184838.26166549@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0903261525560.3032@localhost.localdomain>
In-reply-To: <alpine.LFD.2.00.0903261525560.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903270115.32071.elendil@planet.nl>
X-OriginalArrivalTime: 27 Mar 2009 00:15:32.0601 (UTC) FILETIME=[24A39E90:01C9AE71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> If the distro's had done this right in the year+ that this has been in,
> I might consider your NAK to have some weight.
> 
> As it is, we know that didn't happen, and we've had three different
> people from different distributions say that they wanted to use relatime
> anyway, so it's now the default in my git tree.
> 
> If you want to live in some dark ages, you can do so with the
> "strictatime" thing.

I obviously welcome the inclusion of the first patch and I'm neutral about 
the second one, but I'm not at all sure that making relatime the default 
(yet) is the right thing, especially as util-linux' mount command does 
not yet even support that "strictatime" thing. Shouldn't that at least 
happen first (and have been supported in distro's stable releases for 
some time)?

I guess users and distros can still elect not to set it as default, but it 
still seems a bit like going from one extreme to another.
