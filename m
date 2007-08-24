Return-Path: <linux-kernel-owner+w=401wt.eu-S933473AbXHXNCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbXHXNCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 09:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762764AbXHXNCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 09:02:22 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56048 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764359AbXHXNCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 09:02:20 -0400
Date: Fri, 24 Aug 2007 15:02:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] dynamic pipe resizing
In-Reply-To: <20070824085221.GA23758@kernel.dk>
Message-ID: <Pine.LNX.4.64.0708241500370.28540@fbirervta.pbzchgretzou.qr>
References: <20070824085221.GA23758@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 24 2007 10:52, Jens Axboe wrote:
>Hi,
>
>Dabbling around with splice a bit, I added some code to change the size
>of a pipe. Currently it's hardcoded as 16 pages, with this patch you can
>shrink (if you wanted) or grow (the likely scenario) if you want to
>increase the size of your in-kernel buffer for splice operations.

Wonderful, I just did the same {-.-}
(but then dropped the patch because it did not help my application at all,
so never mind).

>Like with my original splice patches from 2005, I used fcntl()
>F_GETPIPE_SZ and F_SETPIPE_SZ to change the size of the pipe. I'm not
>particularly fond of that interface, so suggestions on how to improve it
>would be appreciated. Even if fcntl() should be the preferred approach,
>I think it would be better to pass in a byte based value instead of a
>number of pages.

And using  % pipe->buffers then?


	Jan
-- 
