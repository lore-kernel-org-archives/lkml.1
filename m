Return-Path: <linux-kernel-owner+w=401wt.eu-S1762007AbXJQTqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762007AbXJQTqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbXJQTqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:46:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40419 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752450AbXJQTqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:46:36 -0400
Date: Wed, 17 Oct 2007 12:45:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
In-Reply-To: <20071017193542.GA15552@kernel.dk>
Message-ID: <alpine.LFD.0.999.0710171244330.26902@woody.linux-foundation.org>
References: <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk>
 <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk>
 <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu>
 <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk>
 <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org>
 <20071017193542.GA15552@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Jens Axboe wrote:
> 
> OK, I think you have a very good point here. Ingo, can you verify it
> goes away if apply the below? I have to tend to Other Life stuff but
> will take this up again tomorrow morning and fix the sg_next() usage.

This one will only fix the ones that use the SCSI-lib routines, so it will 
leave everything else broken, no?

> Linus, please still pull the branch I asked you to earlier. Thanks!

Already did.

		Linus
