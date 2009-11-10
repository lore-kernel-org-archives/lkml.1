Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZKJPDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZKJPDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbZKJPDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:03:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516AbZKJPDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:03:32 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC, PATCH] cfq-iosched: remove redundant queuing detection code
References: <200911101454.57522.czoccolo@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 10 Nov 2009 10:03:32 -0500
In-Reply-To: <200911101454.57522.czoccolo@gmail.com> (Corrado Zoccolo's
	message of "Tue, 10 Nov 2009 14:54:57 +0100")
Message-ID: <x49vdhi5smz.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> The core block layer already has code to detect presence of command
> queuing devices. We convert cfq to use that instead of re-doing the
> computation.

This sounds like a good idea to me, and it appears the same number of
requests will be used to detect command queuing.  I'm surprised we can't
just query each device to detect this, honestly.

One thing you missed, though, was removing the CFQ_HW_QUEUE_MIN define.

Cheers,
Jeff
