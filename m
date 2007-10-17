Return-Path: <linux-kernel-owner+w=401wt.eu-S1762186AbXJQTGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762186AbXJQTGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932109AbXJQTEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:04:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51370 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761175AbXJQTEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:04:46 -0400
Date: Wed, 17 Oct 2007 21:04:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071017190422.GA12711@elte.hu>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017183716.GU15552@kernel.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.1.7-deb
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2559]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


btw., i get the following build warning:

drivers/scsi/scsi_lib.c: In function 'scsi_free_sgtable':
drivers/scsi/scsi_lib.c:708: warning: 'index' may be used uninitialized in this function
drivers/scsi/scsi_lib.c:708: note: 'index' was declared here
drivers/scsi/scsi_lib.c:708: warning: 'index' may be used uninitialized in this function
drivers/scsi/scsi_lib.c:708: note: 'index' was declared here
drivers/scsi/scsi_lib.c: In function 'scsi_alloc_sgtable':
drivers/scsi/scsi_lib.c:708: warning: 'index' may be used uninitialized in this function
drivers/scsi/scsi_lib.c:708: note: 'index' was declared here

not sure it matters.

	Ingo
