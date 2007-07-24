Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbXGXMwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbXGXMwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbXGXMwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 08:52:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:33019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbXGXMwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 08:52:35 -0400
From: Andreas Schwab <schwab@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.392129000@pademelon.sonytel.be>
	<20070718163637.3f0e0164.akpm@linux-foundation.org>
	<46A5E610.7000508@shadowen.org> <46A5F275.7060905@garzik.org>
X-Yow: I'm having a MID-WEEK CRISIS!
Date: Tue, 24 Jul 2007 14:52:32 +0200
In-Reply-To: <46A5F275.7060905@garzik.org> (Jeff Garzik's message of "Tue\, 24
	Jul 2007 08\:37\:09 -0400")
Message-ID: <je3aze6k1b.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Andy Whitcroft wrote:
>> Andrew Morton wrote:
>> 
>>>> +	start_sector = req->sector*priv->blocking_factor;
>>>> +	sectors = req->nr_sectors*priv->blocking_factor;
>>> s/*/ * /.  checkpatch missed this.
>> 
>> Ok, this is something we need to decide on.  Currently we only ask for
>> consistent spacing on all the mathematic operators.  This is mostly as
>> we do see a large number of non-spaced uses in defines and the like.
>> 
>> I am happy to expand these tests so they are always spaced on both sides
>> style if that is the preference.
>
> That is most definitely the preference:  spaces surround operators.
                                                          ^binary

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
