Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYIXTwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYIXTwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYIXTw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:52:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54513
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751528AbYIXTw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:52:27 -0400
Date: Wed, 24 Sep 2008 12:52:15 -0700 (PDT)
Message-Id: <20080924.125215.46439097.davem@davemloft.net>
To: kyle@mcmartin.ca
Cc: airlied@gmail.com, jkosina@suse.cz, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080924191022.GC2591@phobos.i.cabal.ca>
References: <21d7e9970809232245x6a91c6e2l552ff039d07e2017@mail.gmail.com>
	<20080924.003638.71148740.davem@davemloft.net>
	<20080924191022.GC2591@phobos.i.cabal.ca>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@mcmartin.ca>
Date: Wed, 24 Sep 2008 15:10:22 -0400

> I've been working on a patch to detect (using a timer and checking at
>  up/down) whether or not the flash has been corrupted, and, if it is
> rewrite it with the saved good copy (which obviously only helps if
> it's the same boot.)

Looks interesting, I hope someone runs with it :-)

If the flash is seen as corrupt, we should print the current process
that is running at the time, and perhaps a pt_regs dump, as these
might provide the most important clues to diagnosing this.
