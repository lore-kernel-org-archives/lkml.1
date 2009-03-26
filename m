Return-Path: <linux-kernel-owner+w=401wt.eu-S1761996AbZCZXYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761996AbZCZXYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbZCZXYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:24:01 -0400
Received: from ara.aytolacoruna.es ([91.117.124.165]:41303 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758593AbZCZXYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:24:01 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2009 19:24:01 EDT
Date: Fri, 27 Mar 2009 00:15:15 +0100
From: Santiago Garcia Mantinan <manty@manty.net>
To: linux-kernel@vger.kernel.org
Subject: uli526x hangs on 2.6.29, not on rc8
Message-ID: <20090326231515.GA6612@dis.manty.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

After upgrading from rc8 to final 2.6.29 my machine's network stops working
after some full speed (100Mb/s) downloads ifdown;ifup, or powering off the
switch won't solve the problem, however it is solved if I unload the driver
module and load it again. Tested with another NIC (e1000e based) and
couldn't reproduce the problem.

This is happening on final 2.6.29 version but doesn't seem to happen on rc8
with the same kernel config. Machine is a AMD Athlon 64 running Debian 64
bits.

I don't see any changes on the git for uli526x from rc8 to final, but the
tulip driver on which this one is based had some changes.

Don't know what else to add, just ask me for whatever data that may help on
this.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
