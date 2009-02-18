Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbZBRP67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbZBRP67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbZBRP6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:58:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693AbZBRP6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:58:43 -0500
Date: Wed, 18 Feb 2009 16:58:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: scsi: aic7xxx hang since v2.6.28-rc1 ...
Message-ID: <20090218155817.GC23989@elte.hu>
References: <20090215115823.GB19464@elte.hu> <Pine.LNX.4.44L0.0902171507370.18399-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0902171507370.18399-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> I have no idea if this will make any difference for the 
> problem you're seeing, but it has been submitted and it's 
> worth trying out.  If the problem still occurs, I'll write a 
> diagnostic patch to add log messages giving the destiny of 
> each request in scsi_io_completion().

OK, i've undone the reverts and have applied your fix - it will 
take a few hours to see whether the hang still occurs.

	Ingo
