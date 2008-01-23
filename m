Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbYAWTcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbYAWTcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYAWTcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:32:00 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4108 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbYAWTb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:31:59 -0500
Date: Wed, 23 Jan 2008 14:02:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Silent crash witk 2-6.24-rc8-git4
Message-ID: <20080123190207.GB3129@tuxdriver.com>
References: <200801220603.02986.chris2553@googlemail.com> <200801231521.36968.chris2553@googlemail.com> <200801231642.58782.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801231642.58782.chris2553@googlemail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 04:42:58PM +0000, Chris Clayton wrote:
> On Wednesday 23 January 2008, Chris Clayton wrote:
> > Hi again.
> > 
> > On Tuesday 22 January 2008, Chris Clayton wrote:
> > > Hi,
> 
> and here's another, slightly more complete, one, this time from 2.6.24-rc8-git6
> (the none I sent earlier was from -git4, by the way)
> 
> Call Trace:
> [<c011440a>] __update_rq_clock+0x1a/0xf0
> [<e08ff59d>] rt2x00lib_txdone+0x9d/0xd0 [rt2x00lib]
> [<e0909573>] rt61pci_txdone+0x153/0x1f0 [rt61pci]
> [<e09096ad>] rt61pci_interrupt+0x9d/0xb0 [rt61pci]

I suspect this could relate to this commit:

commit 62bc060b8ed5fcdafd87da5ab17bdd59a39ebcc9
Author: Mattias Nissler <mattias.nissler@gmx.de>
Date:   Mon Nov 12 15:03:12 2007 +0100

    rt2x00: Allow rt61 to catch up after a missing tx report

Could you revert that patch, rebuild, and try to recreate the problem?

Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
