Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZFXJ4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZFXJ4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZFXJ4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:56:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50806
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320AbZFXJ4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:56:00 -0400
Date: Wed, 24 Jun 2009 02:56:04 -0700 (PDT)
Message-Id: <20090624.025604.162446127.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       petkovbb@gmail.com, htejun@gmail.com
Subject: Re: [patch 3/6] ide: always kill the whole request on error
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906241138.00687.bzolnier@gmail.com>
References: <200906240249.33505.bzolnier@gmail.com>
	<20090623.234948.121450964.davem@davemloft.net>
	<200906241138.00687.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Wed, 24 Jun 2009 11:38:00 +0200

> On Wednesday 24 June 2009 08:49:48 David Miller wrote:
>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Date: Wed, 24 Jun 2009 02:49:32 +0200
>> 
>> The previous patch is a prerequesite for this one.  So we should
>> discuss them as a whole.  Because if we can't remove the "ide/floppy
>> RQ error 0 instead of -EIO" bit, then we don't make these further
>> consolidations either.
> 
> Untrue, we can easily redo the patch #3 to not be dependent on patch #2.

Good point.

> Do you prefer such version instead?

Let's wait until we come to some conclusion about patch #2.
