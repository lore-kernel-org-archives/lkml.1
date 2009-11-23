Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZKWTyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZKWTyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbZKWTyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:54:24 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59479 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbZKWTyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:54:23 -0500
Date: Mon, 23 Nov 2009 19:54:15 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Pavel Machek <pavel@ucw.cz>, Kay Sievers <kay.sievers@vrfy.org>,
       David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle
	changes
Message-ID: <20091123195415.GA16833@srcf.ucam.org>
References: <ac3eb2510911181147ufeacb58u5194b0e1e5fd86d6@mail.gmail.com> <20091118195342.GA13627@srcf.ucam.org> <ac3eb2510911181203r1be5c3dajdacec94f196d550c@mail.gmail.com> <20091118200712.GA14026@srcf.ucam.org> <20091122233749.GA9699@ucw.cz> <20091123141754.GE8742@kernel.dk> <20091123142557.GA10084@srcf.ucam.org> <20091123143140.GG8742@kernel.dk> <20091123144238.GA10275@srcf.ucam.org> <20091123195000.GK8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123195000.GK8742@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 08:50:00PM +0100, Jens Axboe wrote:

> If the polling works out, then yes that approach is certainly a lot
> better from a performance impact pov.
> 
> What kind of time intervals are you targetting?

On the order of a second. I'm doing benchmarking with my current 
implementation now, I'll let you know how it looks.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
