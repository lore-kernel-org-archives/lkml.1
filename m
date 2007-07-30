Return-Path: <linux-kernel-owner+w=401wt.eu-S967875AbXG3TEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967875AbXG3TEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966506AbXG3TEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:04:21 -0400
Received: from mailhost.nmt.edu ([129.138.4.52]:60457 "EHLO mailhost.nmt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763159AbXG3TEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:04:20 -0400
Date: Mon, 30 Jul 2007 13:04:13 -0600
From: Valerie Henson <val@nmt.edu>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       tulip-users@lists.sourceforge.net
Cc: Grant Grundler <grundler@parisc-linux.org>, Jeff Garzik <jeff@garzik.org>
Subject: [TULIP] Need new maintainer
Message-ID: <20070730190412.GA16182@rainbow>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Tulip network driver needs a new maintainer!  I no longer have
time to maintain the Tulip network driver and I'm stepping down.  Jeff
Garzik would be happy to get volunteers.

The only current major outstanding patch I know of is Grant's shutdown
race patch, which was incorrectly dropped as obsoleted from -mm (my
fault, I was moving at the time):

http://www.mail-archive.com/mm-commits@vger.kernel.org/msg12161.html

I have a very much non-working patch to do it with the preferred
order, ask me for it and I'll see if I can dig it up.  It's unpleasant
partly because it pointed out a lot of latent bugs (e.g.,
del_timer_sync() in interrupt context).

Also, someone is working on support for an emulated Tulip card (yes,
Tulip will _never_ die), so expect possible patches for that.

-VAL
