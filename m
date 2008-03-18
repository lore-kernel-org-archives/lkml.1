Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbYCRJwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbYCRJwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 05:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYCRJwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 05:52:16 -0400
Received: from mx1.suse.de ([195.135.220.2]:55035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbYCRJwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 05:52:15 -0400
Subject: ide_cd modifies hard_* members of request
From: Nikanth Karthikesan <knikanth@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@googlemail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain
Date: Tue, 18 Mar 2008 14:24:46 +0530
Message-Id: <1205830486.7126.16.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Despite the warning in blkdev.h, that members of struct request starting
with hard_* are block layer internals, and no driver should touch them,
the ide_cd driver seems to fiddle around with it.

Is this reqd, or can this be made to work without the need for this?

If this reqd, why not provide a helper function for that in block layer
itself, may be, with a warning about usage?

Thanks
Nikanth Karthikesan


