Return-Path: <linux-kernel-owner+w=401wt.eu-S932997AbXCVOda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbXCVOda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 10:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbXCVOda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 10:33:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45913 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997AbXCVOd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 10:33:29 -0400
Date: Thu, 22 Mar 2007 14:33:14 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Tomas M <tomas@slax.org>,
       linux-kernel@vger.kernel.org
Subject: Re: max_loop limit
Message-ID: <20070322143314.GX4095@ftp.linux.org.uk>
References: <460236CE.1030303@slax.org> <20070322110058.GB23664@tatooine.rebelbase.local> <46026A92.4020106@slax.org> <20070322144210.73dfaf83.dada1@cosmosbay.com> <20070322134230.GP19922@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322134230.GP19922@kernel.dk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 02:42:31PM +0100, Jens Axboe wrote:
> But this still wastes memory, why not just allocate each loop device
> dynamically when it is set up? The current approach is crap, it is just
> wasting memory for loop devices, queues, etc.

Correction: current ABI is crap.  To set the thing up you need to open
it and issue an ioctl.  Which is a bloody bad idea, for obvious reasons...
