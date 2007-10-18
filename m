Return-Path: <linux-kernel-owner+w=401wt.eu-S1762008AbXJRHHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008AbXJRHHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 03:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbXJRHHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 03:07:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40187 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbXJRHHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 03:07:21 -0400
Date: Thu, 18 Oct 2007 09:07:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018070706.GA7435@elte.hu>
References: <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017193542.GA15552@kernel.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -39,7 +39,7 @@
>   * (unless chaining is used). Should ideally fit inside a single page, to
>   * avoid a higher order allocation.
>   */
> -#define SCSI_MAX_SG_SEGMENTS	128
> +#define SCSI_MAX_SG_SEGMENTS	129

this one finally made the trick and it's booting fine now, without any 
crashes!

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
