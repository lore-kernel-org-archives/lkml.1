Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbXEOVIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbXEOVIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 17:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXEOVIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 17:08:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbXEOVIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 17:08:30 -0400
Date: Tue, 15 May 2007 17:08:04 -0400
From: Dave Jones <davej@redhat.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Francesco Pretto <ceztko@gmail.com>, Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Message-ID: <20070515210804.GG25902@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Tejun Heo <htejun@gmail.com>, Francesco Pretto <ceztko@gmail.com>,
	Phillip Susi <psusi@cfl.rr.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no> <45DD0348.5040005@shaw.ca> <e5ab0f710702231235ucb559eerb3639ec312aa312a@mail.gmail.com> <463B858E.6060002@cfl.rr.com> <463B99EE.2090001@gmail.com> <e5ab0f710705061119k35ba223j2ecca6e0f8495ed5@mail.gmail.com> <46489D3B.8050805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46489D3B.8050805@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 07:32:43PM +0200, Tejun Heo wrote:
 > Francesco Pretto wrote:
 > > 2007/5/4, Tejun Heo <htejun@gmail.com>:
 > >> Yeap, the third iteration of the patch just got submitted.
 > >>
 > >>   http://thread.gmane.org/gmane.linux.ide/18485
 > >>
 > >> Unfortunately, there doesn't seem to be an easy way out.  We'll need
 > >> userland shutdown(8) update.
 > >>
 > >> -- 
 > >> tejun
 > >>
 > > 
 > > Ok, i can't understand if the patch will be included in 2.6.22 (i
 > > didn't see it in the Andrew Morton merge plan). However, if you can
 > > confirm the inclusion, i can send bug reports for ubuntu and gentoo. I
 > > can even send an email to Miquel van Smoorenburg, who should be the
 > > mainstream sysvinit developer (and probably the last maintainer).
 > 
 > Okay, the patch made upstream and webpage posted.
 > 
 >  http://linux-ata.org/shutdown.html

There's a typo..

"Check whether /sys/modules/libata/parameters/spindown_compat  exists. If it does, write 0 to it."

should be /sys/module/libata/parameters/spindown_compat

(no 's' after module)

	Dave


-- 
http://www.codemonkey.org.uk
