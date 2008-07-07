Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbYGGNF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbYGGNF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 09:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYGGNFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 09:05:14 -0400
Received: from aun.it.uu.se ([130.238.12.36]:58832 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbYGGNFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 09:05:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18546.5247.797478.66373@harpo.it.uu.se>
Date: Mon, 7 Jul 2008 15:05:03 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Miller <davem@davemloft.net>
Cc: a.beregalov@gmail.com, kernel-testers@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
In-Reply-To: <20080707.040126.178187777.davem@davemloft.net>
References: <20080620.162135.203810660.davem@davemloft.net>
	<a4423d670806201636n4f3d107bk290ed831eb5eefb4@mail.gmail.com>
	<a4423d670807070219s2dd43aaia29713f5076ecd0d@mail.gmail.com>
	<20080707.040126.178187777.davem@davemloft.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:
 > From: "Alexander Beregalov" <a.beregalov@gmail.com>
 > Date: Mon, 7 Jul 2008 13:19:05 +0400
 > 
 > > Hi David
 > > 
 > > Is it possible to add some debug code to understand what is going on?
 > 
 > What do you want me to add?  The thing hangs and we have no idea
 > where since there are no messages on the console and the hang
 > happens before we have any kind of console output.
 > 
 > Why do you think I haven't been able to fix this yet?
 > 
 > Besides I'm too busy with some networking stuff to work at
 > all on this at the moment, so folks will just need to be
 > patient or do the grunt work of debugging this themselves.

My Ultra 5 (same mainboard as the Ultra 10) boots 2.6.26-rc9
just fine. So Alexander's problem is probably caused by .config
settings or his toolchain.

My working 2.6.26-rc9 .config and a boot log are available in
<http://user.it.uu.se/~mikpe/linux/ultra5/> in case someone wants
to use them as a starting point for debugging this problem.

The toolchain I used has gcc-4.3.1 and binutils-2.17.50.0.3.

/Mikael
