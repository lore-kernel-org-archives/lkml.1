Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYKBV2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYKBV2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbYKBV2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:28:15 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52675 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754084AbYKBV2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:28:14 -0500
Date: Sun, 2 Nov 2008 16:28:12 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [Bug #11905] lots of extra timer interrupts costing 2W
Message-ID: <20081102212811.GL8134@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Venki Pallipadi <venkatesh.pallipadi@intel.com>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera> <wOAXuecskPD.A.xRF.DkeDJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wOAXuecskPD.A.xRF.DkeDJB@chimera>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2008 at 05:07:06PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11905
> Subject		: lots of extra timer interrupts costing 2W
> Submitter	: Theodore Ts'o <tytso@mit.edu>
> Date		: 2008-10-30 2:18 (4 days old)
> References	: http://marc.info/?l=linux-kernel&m=122533314305315&w=4
> 		  http://marc.info/?l=linux-kernel&m=122541849114444&w=4

Yup, should still be listed.  

Is someone looking what the proper fix should be (other than reverting
the commit in question)?  I've been running with the commit reverted
on my laptop kernel for a couple of days now, with no problems.

						- Ted


