Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbXJQSPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbXJQSPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760100AbXJQSO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:14:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44591 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760049AbXJQSO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:14:57 -0400
Date: Wed, 17 Oct 2007 11:08:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
In-Reply-To: <20071017174503.GA4622@elte.hu>
Message-ID: <alpine.LFD.0.999.0710171104570.26902@woody.linux-foundation.org>
References: <20071017154655.GA13394@elte.hu>
 <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org>
 <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk>
 <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk>
 <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Ingo Molnar wrote:
> 
> ok, here's a different but similar crash that triggers on the testbox:

Just to confirm - is this with the added memset() in 
drivers/scsi/scsi_lib.c?

Or did you get this oops before that patch?

		Linus
