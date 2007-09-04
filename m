Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbXIDLLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbXIDLLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 07:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbXIDLLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 07:11:16 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26559 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbXIDLLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 07:11:16 -0400
Date: Tue, 4 Sep 2007 13:06:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Micah Gruber <micah.gruber@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       gregkh@suse.de
Subject: Re: [PATCH] Fix a potential NULL pointer dereference in
	usbat_check_status()  in drivers/usb/storage/shuttle_usbat.c
Message-ID: <20070904110651.GB5126@kernel.dk>
References: <46DD1661.4070500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DD1661.4070500@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04 2007, Micah Gruber wrote:
> This patch fixes a potential null dereference bug where we dereference us before a null check. This patch simply moves the dereferencing after the null check.
> 
> Signed-off-by: Micah Gruber <micah.gruber@gmail.com>

Be careful with stuff like that, if you actually look at the code, a us
== NULL doesn't seem to be possible (or usbat_flash_transport() would
have oopsed before).

-- 
Jens Axboe

