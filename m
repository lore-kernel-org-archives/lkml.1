Return-Path: <linux-kernel-owner+w=401wt.eu-S933396AbXJPNXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396AbXJPNXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 09:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757896AbXJPNXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 09:23:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:35884 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755248AbXJPNXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 09:23:46 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX18nULsSvyInoOjHsJ9nhTDAtD41fDgweWIG4v5gX2
	2MQw5VG2Kf8frp
From: Jan-Simon =?iso-8859-1?q?M=F6ller?= <dl9pf@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [BUG] memory leak in dm
Date: Tue, 16 Oct 2007 15:23:46 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Kristof Provost <Kristof@provost-engineering.be>,
       linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>
References: <20071016113800.GA4631@luggage> <20071016114458.GD5263@kernel.dk>
In-Reply-To: <20071016114458.GD5263@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161523.47111.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 16 Oktober 2007 13:44:58 schrieb Jens Axboe:
> Please try with this patch from Neil.
Tried the patch. Now its usable - as far as i can say. Compiled a fresh kernel 
to "stress" the system (make -j3).
Without the patch the system had freezed after some minutes during compile.

::::::::::::::
../free_before
::::::::::::::
             total       used       free     shared    buffers     cached
Mem:       2053260     691856    1361404          0       5884     324868
-/+ buffers/cache:     361104    1692156
Swap:      2104472          0    2104472

::::::::::::::
../free_after
::::::::::::::
             total       used       free     shared    buffers     cached
Mem:       2053260    2006588      46672          0         32    1492360
-/+ buffers/cache:     514196    1539064
Swap:      2104472         96    2104376


Greets
Jan-Simon
