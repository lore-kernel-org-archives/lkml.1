Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbXKLPVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbXKLPVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbXKLPVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:21:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbXKLPVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:21:03 -0500
Date: Mon, 12 Nov 2007 15:21:00 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: build #338 failed for 2.6.24-rc2-g6e800af in linux/drivers/md/dm-mpath-hp-sw.c
Message-ID: <20071112152100.GA22847@agk.fab.redhat.com>
Mail-Followup-To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org
References: <200711121333.24398.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200711121333.24398.toralf.foerster@gmx.de>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 01:33:21PM +0100, Toralf Förster wrote:
> the build with the attached .config failed, make ends with:
> drivers/built-in.o: In function `hp_sw_end_io':
> dm-mpath-hp-sw.c:(.text+0xb0596): undefined reference to `__scsi_print_sense'
> make: *** [.tmp_vmlinux1] Error 1
 
Does this patch fix it?
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-mpath-hp-requires-scsi.patch

Alasdair

