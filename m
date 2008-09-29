Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbYI2Ow0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbYI2Ow0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 10:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYI2OwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 10:52:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:59229 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYI2OwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 10:52:17 -0400
To: Neil Brown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH] md: Add support for data integrity to MD
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <yq1y71mmjvw.fsf@sermon.lab.mkp.net>
	<18649.43504.157272.351801@notabene.brown>
Date: Mon, 29 Sep 2008 10:51:54 -0400
In-Reply-To: <18649.43504.157272.351801@notabene.brown> (Neil Brown's message of "Wed\, 24 Sep 2008 12\:46\:08 +1000")
Message-ID: <yq1ej33f1it.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Neil" == Neil Brown <neilb@suse.de> writes:

Neil> But what if we subsequently add a different device to that array
Neil> which uses a different protection format.  Would we be able to
Neil> tell the filesystem that integrity protection isn't available
Neil> any more?  Or can we detect if the filesystem is using integrity
Neil> protection, and reject the new device if it doesn't match?

Generally the filesystem will look at the block device's integrity
profile every time it prepares an I/O.  So if we add a subdevice and
detect a mismatch the mddev integrity profile should be removed.


Neil> In either case, some extra handling is needed in
Neil> bind_rdev_to_array.

This code has been sitting in my patch queue for several months
waiting for the core of the integrity stuff to go in.  So I'm a bit
fuzzy on the details.  I'll take a look...

-- 
Martin K. Petersen	Oracle Linux Engineering

