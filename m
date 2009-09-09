Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbZIIRG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbZIIRG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZIIRG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:06:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49623 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753357AbZIIRGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:06:55 -0400
Date: Wed, 9 Sep 2009 18:08:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ed Cashin <ecashin@coraid.com>
Cc: ecashin@coraid.com, jens.axboe@oracle.com, akpm@linux-foundation.org,
       apw@canonical.com, bonbons@linux-vserver.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aoe: end barrier bios with EOPNOTSUPP
Message-ID: <20090909180804.3e62331a@lxorguk.ukuu.org.uk>
In-Reply-To: <60772f633c524ba873f569966fccd6ce@coraid.com>
References: <200909021955.n82JtkrI032267@imap1.linux-foundation.org>
	<20090903063539.GH12579@kernel.dk>
	<2339aa04a4e8fb440a52624273728352@coraid.com>
	<20090904183525.GB18599@kernel.dk>
	<f48e25c99e41e375f2ddd85989cd39e1@coraid.com>
	<20090905051735.GH18599@kernel.dk>
	<366469f19c41e0150028b886f6859019@coraid.com>
	<20090908193540.GB18599@kernel.dk>
	<60772f633c524ba873f569966fccd6ce@coraid.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The bio in question is a barrier.  Jens Axboe suggested that such bios
> need to be recognized and ended with -EOPNOTSUPP by any driver that
> provides its own ->make_request_fn handler and does not handle
> barriers.
> 
> In testing the changes below eliminate the BUG.

Presumably AoE should actually issue an ATA cache flush for this case ?

