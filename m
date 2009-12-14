Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbZLNTFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbZLNTFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757253AbZLNTFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:05:51 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:49621 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176AbZLNTFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:05:51 -0500
Date: Mon, 14 Dec 2009 19:05:44 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] laptop-mode: Make flushes per-device
Message-ID: <20091214190544.GA6589@srcf.ucam.org>
References: <20091211164433.GA1980@srcf.ucam.org> <1260554071-2190-1-git-send-email-mjg@redhat.com> <20091212122443.GA8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091212122443.GA8742@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 01:24:43PM +0100, Jens Axboe wrote:

> That's because it is messy, why are you passing the request in? It
> would be a lot more sane to pass in the queue, better still the backing
> device.

It seemed conceptually cleaner for the completion to refer to the 
request rather than anything else, but that's easily fixed.

> What guarentees that the timer isn't running when the bdi goes away?

Good point. I'll fix these and resend.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
