Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbXFVJdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbXFVJdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 05:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbXFVJdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 05:33:09 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:37252 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbXFVJdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 05:33:08 -0400
Date: Fri, 22 Jun 2007 11:34:36 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org
Message-ID: <20070622093436.GA17828@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: PXA270 sleeping problems after update
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just updated my linux tree from 2.6.20-rc6 to 2.6.22-rc3 for my
custom PXA270 based board and I discovered that now sleep/wakeup
functionality doesn't work anymore! :'(

After several merges, compiling stages and tests I discovered that the
problem arises from 2.6.21 to 2.6.22-rc1 and that the _real_ problem
is that the machine never goes to sleep (I discovered that by looking
at current consuming since the JTAG doesn't attach...).

Any suggestions?

Thanks a lot,

Rodolfo


-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
