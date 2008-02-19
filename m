Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbYBSH7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbYBSH7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 02:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbYBSH6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 02:58:50 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:21660 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbYBSH6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 02:58:50 -0500
Message-ID: <47BA8C27.6020108@msgid.tls.msk.ru>
Date: Tue, 19 Feb 2008 10:58:31 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Jeremy Higdon <jeremy@sgi.com>
CC: David Chinner <dgc@sgi.com>, Ric Wheeler <ric@emc.com>,
       device-mapper development <dm-devel@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device
 DM devices
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080215142010.GA29552@one.firstfloor.org> <20080215141229.GB1788@agk.fab.redhat.com> <47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru> <20080218221644.GN155407@sgi.com> <20080219071948.GA244758@sgi.com>
In-Reply-To: <20080219071948.GA244758@sgi.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Higdon wrote:
[]
> I'll put it even more strongly.  My experience is that disabling write
> cache plus disabling barriers is often much faster than enabling both
> barriers and write cache enabled, when doing metadata intensive
> operations, as long as you have a drive that is good at CTQ/NCQ.

Now, and it's VERY interesting at least for me (and is off-topic in
this thread) -- which drive(s) are good at NCQ?  I tried numerous SATA
(NCQ is about sata, right? :) drives, but NCQ either does nothing in
terms of performance or hurts.  Yesterday we ordered another drive
from Hitachi (their "raid edition" thing), -- will try it tomorrow,
but I've no hope here as it's some 5th or 6th model/brand already.

(Ol'good SCSI drives, even 10 years old, shows large difference when
TCQ is enabled...)

Thanks!
