Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbXDNEmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbXDNEmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 00:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbXDNEmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 00:42:24 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:47054 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbXDNEmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 00:42:23 -0400
X-Greylist: delayed 894 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Apr 2007 00:42:23 EDT
Date: Sat, 14 Apr 2007 06:27:25 +0200
From: Jan Kasprzak <kas@fi.muni.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: MOXA: mxser_new lockup
Message-ID: <20070414042725.GT20376@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Envelope-To: linux-kernel@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sat, 14 Apr 2007 06:27:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

I have a MOXA C168H card, and after the upgrade from 2.6.19 to 2.6.21-rc6
(and from moxa.c to mxser_new.c) I get a system lockup after few seconds
of communicating over the MOXA serial line. Noting is printed on the
serial console at all. The system is SMP x86_64 (Fedora 5). I may be
able to do a limited testing on request, but the system is in production
use most of the time. For now, I will probably move back to the older
driver.

	Are you aware of any SMP or 64-bit issues in mxser_new.c?
Thanks,

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
> I will never go to meetings again because I think  face to face meetings <
> are the biggest waste of time you can ever have.        --Linus Torvalds <
