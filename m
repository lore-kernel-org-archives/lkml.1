Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbXKCGYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbXKCGYd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 02:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756379AbXKCGYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 02:24:25 -0400
Received: from THUNK.ORG ([69.25.196.29]:33514 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbXKCGYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 02:24:24 -0400
Date: Sat, 3 Nov 2007 02:23:04 -0400
From: Theodore Tso <tytso@mit.edu>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org
Subject: Re: Suspend to ram regression (2.6.24-rc1-git)
Message-ID: <20071103062304.GA10428@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	jeff@garzik.org, linux-ide@vger.kernel.org
References: <20071031201308.GK11514@kernel.dk> <20071101084145.GA5037@kernel.dk> <20071102163708.15304989.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102163708.15304989.kristen.c.accardi@intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 04:37:08PM -0700, Kristen Carlson Accardi wrote:
> 
> Does this patch fix your problem?  It seems to get hung up while disabling
> DIPM, and after thinking about this a bit, I don't think we really need
> to do this anyway.

Yep, this fixes suspend/resume on my X61 thinkpad.  Interestingly I'm
not seeing any power savings with ALPM set to min_power, at least not
compared to what I get after suspend and resuming (which mysteriously
cause the power utilization of my laptop to drop by a watt --- maybe
that is engaging ALPM as part of the suspend process?  I dunno).

     		      	      	 - Ted
