Return-Path: <linux-kernel-owner+w=401wt.eu-S933847AbXJSRi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847AbXJSRi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761293AbXJSRis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:38:48 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:38390 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607AbXJSRir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:38:47 -0400
Date: Fri, 19 Oct 2007 19:41:14 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Message-ID: <20071019174113.GE20509@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [RFC] LinuxPPS (pre)patch
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

here my last patch of LinuxPPS.

Main differences from old versions is that now (finally) each PPS
source is a dedicated char device!

This thanks to an agreement with NTP people who suggested to me how to
interpret RFC 2783 in such a way even a dedicated char device is now
RFC complain.

Please, take a look at the code and report all suggestions and/or
needed modifications for kernel inclusion so I can provide a final
patch.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
