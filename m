Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbYFAVTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbYFAVTy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYFAVTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:19:47 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42388 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbYFAVTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:19:47 -0400
Date: Sun, 1 Jun 2008 22:19:44 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: =?iso-8859-15?Q?Simon_Holm_Th=F8gersen?= <odie@cs.aau.dk>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [drm:radeon_cp_idle] *ERROR* radeon_cp_idle called without lock
 held
In-Reply-To: <1212347789.2580.9.camel@odie.local>
Message-ID: <alpine.DEB.0.82.0806012218560.5760@skynet.skynet.ie>
References: <1212347789.2580.9.camel@odie.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I can easily trigger an endless stream of the following three lines
> 
> [drm:radeon_cp_idle] *ERROR* radeon_cp_idle called without lock held,
> held  0 owner eb0908c0 eb0908c0
> [drm:radeon_cp_reset] *ERROR* radeon_cp_reset called without lock held,
> held  0 owner eb0908c0 eb0908c0
> [drm:radeon_cp_start] *ERROR* radeon_cp_start called without lock held,

Its a userspace problem not a kernel side one, granted we might throttle 
the messages. Are you running KDE compositing on radeon or something 
likethat?

Dave.
