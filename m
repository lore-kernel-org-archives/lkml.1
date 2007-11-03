Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbXKCRCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbXKCRCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 13:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbXKCRCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 13:02:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52729 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbXKCRCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 13:02:44 -0400
Date: Sat, 3 Nov 2007 10:02:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org
Subject: Re: Suspend to ram regression (2.6.24-rc1-git)
Message-ID: <20071103100223.48831355@laptopd505.fenrus.org>
In-Reply-To: <20071103062304.GA10428@thunk.org>
References: <20071031201308.GK11514@kernel.dk>
	<20071101084145.GA5037@kernel.dk>
	<20071102163708.15304989.kristen.c.accardi@intel.com>
	<20071103062304.GA10428@thunk.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007 02:23:04 -0400
Theodore Tso <tytso@mit.edu> wrote:

> Yep, this fixes suspend/resume on my X61 thinkpad.  Interestingly I'm
> not seeing any power savings with ALPM set to min_power, at least not
> compared to what I get after suspend and resuming (which mysteriously
> cause the power utilization of my laptop to drop by a watt --- maybe
> that is engaging ALPM as part of the suspend process?  I dunno).


ALPM seems to help only if your disk is idle for 2 seconds or more;
unfortunately several standard linux desktops have the disk spin up all
the time via all kinds of things.... there's some "standard guilty"
ones if you're interested in chasing this down..
