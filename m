Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbZL2VhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbZL2VhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZL2VhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:37:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40537 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbZL2VhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:37:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Evgeniy Polyakov <zbr@ioremap.net>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug #14894] pohmelfs: NULL pointer dereference
Date: Tue, 29 Dec 2009 22:37:54 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <srmJ8vMxKPH.A.iAC.TwhOLB@chimera> <20091229163512.GA4958@ioremap.net>
In-Reply-To: <20091229163512.GA4958@ioremap.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912292237.54182.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009, Evgeniy Polyakov wrote:
> On Tue, Dec 29, 2009 at 04:28:52PM +0100, Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14894
> > Subject		: pohmelfs: NULL pointer dereference
> > Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> > Date		: 2009-12-02 1:11 (28 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125971633107940&w=4
> > Handled-By	: Evgeniy Polyakov <zbr@ioremap.net>
> 
> Yes, I saw this regression and there is a patch to handle this, but it
> kind of disables sync at all. Jens Axboe, who introduced per-bdi
> writeback patches, did not yet reply.

Well, Jens, what's your opinion about that?

Rafael
