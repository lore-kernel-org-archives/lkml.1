Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbYFJC67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbYFJC67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 22:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYFJC6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 22:58:52 -0400
Received: from ns1.suse.de ([195.135.220.2]:51338 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbYFJC6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 22:58:51 -0400
Date: Tue, 10 Jun 2008 04:58:48 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug #10614] WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x110/0x11f()
Message-ID: <20080610025848.GD19404@wotan.suse.de>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.XbF.I6vSIB@albercik>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dCRO4tbfLzK.A.XbF.I6vSIB@albercik>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2008 at 10:42:56PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10614
> Subject		: WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x110/0x11f()
> Submitter	: J.A. Magallón <jamagallon@ono.com>
> Date		: 2008-05-01 02:50 (38 days old)
> References	: http://lkml.org/lkml/2008/4/30/614
> Handled-By	: Nick Piggin <npiggin@suse.de>
> 		  Jens Axboe <jens.axboe@oracle.com>

Did Jens fix this up, or...?

I don't think it was ever a problem, just a false positive by the
over eager warning code (still, obviously the warning should be
silenced). J.A., how is the latest git tree going for you?

