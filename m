Return-Path: <linux-kernel-owner+w=401wt.eu-S1762212AbYCCKVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762212AbYCCKVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbYCCKVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:21:21 -0500
Received: from aun.it.uu.se ([130.238.12.36]:43688 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761244AbYCCKVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:21:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18379.53492.171481.255371@harpo.it.uu.se>
Date: Mon, 3 Mar 2008 11:20:36 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, crmafra2@gmail.com,
       linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       htejun@gmail.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.25-rc2-git3 broke cdrecord
In-Reply-To: <18379.51360.744676.894510@harpo.it.uu.se>
References: <20080302233415.GA6258@Pilar>
	<18379.18297.838050.536473@harpo.it.uu.se>
	<tkrat.468fd04c47ae1a2a@s5r6.in-berlin.de>
	<20080303172641Z.fujita.tomonori@lab.ntt.co.jp>
	<47CBC014.9090309@s5r6.in-berlin.de>
	<18379.51360.744676.894510@harpo.it.uu.se>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson writes:
 > Stefan Richter writes:
 >  > FUJITA Tomonori wrote:
 >  > > On Mon, 3 Mar 2008 02:48:23 +0100 (CET)
 >  > > Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
 >  > >> CD burning still fails for me via ide-cd, although in a
 >  > >> different way than without the patch.  (Without the patch, ide-cd also
 >  > >> fails like described by you for SATA.)
 >  > >>
 >  > >> With the patch, the failure is as follows.  I don't know if this is
 >  > >> related to the data length arithmetic or something entirely different;
 >  > >> all I learned so far is that 2.6.24 works.  Application log from
 >  > >> 2.6.25-rc3 + Tejun's patch + Gentoo's cdrkit-1.1.6 + k3b:
 >  > > 
 >  > > Can you try the following patch?
 >  > > 
 >  > > http://lkml.org/lkml/2008/3/2/218
 >  > 
 >  > Fails just like with Tejun's patch, alas.
 > 
 > At this point I must confess I feel very uneasy about this situation.
 > 
 > Dare I suggest the perhaps hereditary solution of reverting these
 > changes and doing them right after 2.6.25 final?

Doh! s/hereditary/heretical/
