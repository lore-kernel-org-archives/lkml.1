Return-Path: <linux-kernel-owner+w=401wt.eu-S936566AbXHGVJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936566AbXHGVJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935772AbXHGUxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:53:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59486 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935751AbXHGUxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:53:34 -0400
Date: Tue, 7 Aug 2007 13:47:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, herton@mandriva.com.br,
       gustavodn@mandriva.com.br, dwmw2@infradead.org, rmk@arm.linux.org.uk
Subject: [2.6.22.2 review 44/84] Include serial_reg.h with userspace headers
Message-ID: <20070807204705.GT23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="include-serial_reg.h-with-userspace-headers.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

As reported by Gustavo de Nardin <gustavodn@mandriva.com.br>, while trying to
compile xosview (http://xosview.sourceforge.net/) with upstream kernel
headers being used you get the following errors:
serialmeter.cc:48:30: error: linux/serial_reg.h: No such file or directory
serialmeter.cc: In member function 'virtual void
SerialMeter::checkResources()':
serialmeter.cc:71: error: 'UART_LSR' was not declared in this scope
serialmeter.cc:71: error: 'UART_MSR' was not declared in this scope
...

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Gustavo de Nardin <gustavodn@mandriva.com.br>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -137,6 +137,7 @@ header-y += radeonfb.h
 header-y += raw.h
 header-y += resource.h
 header-y += rose.h
+header-y += serial_reg.h
 header-y += smbno.h
 header-y += snmp.h
 header-y += sockios.h

-- 
