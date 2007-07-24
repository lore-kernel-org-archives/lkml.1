Return-Path: <linux-kernel-owner+w=401wt.eu-S935646AbXGXLoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935646AbXGXLoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 07:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbXGXLog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 07:44:36 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3799 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbXGXLof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 07:44:35 -0400
Message-ID: <46A5E610.7000508@shadowen.org>
Date: Tue, 24 Jul 2007 12:44:16 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
References: <20070716161539.075822000@pademelon.sonytel.be>	<20070716162206.392129000@pademelon.sonytel.be> <20070718163637.3f0e0164.akpm@linux-foundation.org>
In-Reply-To: <20070718163637.3f0e0164.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>> +	start_sector = req->sector*priv->blocking_factor;
>> +	sectors = req->nr_sectors*priv->blocking_factor;
> 
> s/*/ * /.  checkpatch missed this.

Ok, this is something we need to decide on.  Currently we only ask for
consistent spacing on all the mathematic operators.  This is mostly as
we do see a large number of non-spaced uses in defines and the like.

I am happy to expand these tests so they are always spaced on both sides
style if that is the preference.

-apw
